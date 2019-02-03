/*
 * Copyright (C) 2017 Christopher N. Hesse <raymanfx@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "audio_hw_amplifier_tfa"
#define LOG_NDEBUG 0

#include <cutils/log.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <dlfcn.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>

#include <tinyalsa/asoundlib.h>

#include "tfa.h"

#define I2S_MIXER_CTL "QUAT_MI2S_RX Audio Mixer MultiMedia1"

static int i2s_interface_en(bool enable)
{
    enum mixer_ctl_type type;
    struct mixer_ctl *ctl;
    struct mixer *mixer = mixer_open(0);

    if (mixer == NULL) {
        ALOGE("%s: Error opening mixer 0", __func__);
        return -1;
    }

    ctl = mixer_get_ctl_by_name(mixer, I2S_MIXER_CTL);
    if (ctl == NULL) {
        mixer_close(mixer);
        ALOGE("%s: Could not find %s\n", __func__, I2S_MIXER_CTL);
        return -ENODEV;
    }

    type = mixer_ctl_get_type(ctl);
    if (type != MIXER_CTL_TYPE_BOOL) {
        ALOGE("%s: %s is not supported\n", __func__, I2S_MIXER_CTL);
        mixer_close(mixer);
        return -ENOTTY;
    }

    mixer_ctl_set_value(ctl, 0, enable);
    mixer_close(mixer);
    return 0;
}

static void * write_dummy_data(void *param) {
    tfa_device_t *t = (tfa_device_t *) param;
    uint8_t *buffer;
    int size;
    struct pcm *pcm;
    bool signaled = false;

    struct pcm_config config = {
        .channels = 2,
        .rate = 48000,
        .period_size = DEEP_BUFFER_OUTPUT_PERIOD_SIZE,
        .period_count = DEEP_BUFFER_OUTPUT_PERIOD_COUNT,
        .format = PCM_FORMAT_S16_LE,
        .start_threshold = DEEP_BUFFER_OUTPUT_PERIOD_COUNT / 4,
        .stop_threshold = INT_MAX,
        .avail_min = DEEP_BUFFER_OUTPUT_PERIOD_SIZE / 4,
    };

    if (i2s_interface_en(true)) {
        ALOGE("%s: Failed to enable I2S interface", __func__);
        return NULL;
    }

    pcm = pcm_open(0, 0, PCM_OUT | PCM_MONOTONIC, &config);
    if (!pcm || !pcm_is_ready(pcm)) {
        ALOGE("pcm_open failed: %s", pcm_get_error(pcm));
        if (pcm && errno != EBUSY) {
            goto err_close_pcm;
        }
        goto err_disable_i2s;
    }

    size = DEEP_BUFFER_OUTPUT_PERIOD_SIZE * 8;
    buffer = calloc(1, size);
    if (!buffer) {
        ALOGE("%s: failed to allocate buffer", __func__);
        goto err_close_pcm;
    }

    do {
        if (pcm_write(pcm, buffer, size)) {
            ALOGE("%s: pcm_write failed", __func__);
        }
        if (!signaled) {
            pthread_mutex_lock(&t->mutex);
            t->writing = true;
            pthread_cond_signal(&t->cond);
            pthread_mutex_unlock(&t->mutex);
            signaled = true;
        }
    } while (t->initializing);

    t->writing = false;

err_free:
    free(buffer);
err_close_pcm:
    pcm_close(pcm);
err_disable_i2s:
    i2s_interface_en(false);
    if (!signaled) {
        pthread_mutex_lock(&t->mutex);
        t->writing = true;
        pthread_cond_signal(&t->cond);
        pthread_mutex_unlock(&t->mutex);
    }

    return NULL;
}

static int tfa_clock_on(tfa_device_t *tfa_dev)
{
    if (tfa_dev->clock_enabled) {
        ALOGW("%s: clocks already on", __func__);
        return -EBUSY;
    }

    tfa_dev->initializing = true;
    pthread_create(&tfa_dev->write_thread, NULL, write_dummy_data, tfa_dev);
    pthread_mutex_lock(&tfa_dev->mutex);
    while (!tfa_dev->writing) {
        pthread_cond_wait(&tfa_dev->cond, &tfa_dev->mutex);
    }
    pthread_mutex_unlock(&tfa_dev->mutex);
    tfa_dev->clock_enabled = true;

    ALOGI("%s: clocks enabled", __func__);

    return 0;
}

static int tfa_clock_off(tfa_device_t *tfa_dev)
{
    if (!tfa_dev->clock_enabled) {
        ALOGW("%s: clocks already off", __func__);
        return 0;
    }

    tfa_dev->initializing = false;
    pthread_join(tfa_dev->write_thread, NULL);
    tfa_dev->clock_enabled = false;

    ALOGI("%s: clocks disabled", __func__);

    return 0;
}

/*
 * Loads the vendor amplifier library and grabs the needed functions.
 *
 * @param tfa_dev Device handle.
 *
 * @return 0 on success, <0 on error.
 */
static int load_tfa_lib(tfa_device_t *tfa_dev) {
    if (access(TFA_LIBRARY_PATH, R_OK) < 0) {
        ALOGE("%s: amplifier library %s not found", __func__, TFA_LIBRARY_PATH);
        return -errno;
    }

    tfa_dev->lib_handle = dlopen(TFA_LIBRARY_PATH, RTLD_NOW);
    if (tfa_dev->lib_handle == NULL) {
        ALOGE("%s: dlopen failed for %s (%s)", __func__, TFA_LIBRARY_PATH, dlerror());
        return -1;
    } else {
        ALOGV("%s: dlopen successful for %s", __func__, TFA_LIBRARY_PATH);
    }

    tfa_dev->tfa_device_open = (tfa_device_open_t)dlsym(tfa_dev->lib_handle, "tfa_device_open");
    if (tfa_dev->tfa_device_open == NULL) {
        ALOGE("%s: dlsym error %s for tfa_device_open", __func__, dlerror());
        tfa_dev->tfa_device_open = 0;
        return -1;
    }

    tfa_dev->tfa_enable = (tfa_enable_t)dlsym(tfa_dev->lib_handle, "tfa_enable");
    if (tfa_dev->tfa_enable == NULL) {
        ALOGE("%s: dlsym error %s for tfa_enable", __func__, dlerror());
        tfa_dev->tfa_enable = 0;
        return -1;
    }

    return 0;
}

/*
 * Hooks into the vendor library and enables/disables the amplifier IC.
 *
 * @param tfa_dev Device handle.
 * @param on true or false for enabling/disabling of the IC.
 *
 * @return 0 on success, != 0 on error.
 */
int tfa_power(tfa_device_t *tfa_dev, bool on) {
    int rc = 0;

    ALOGV("%s: %s amplifier device", __func__, on ? "Enabling" : "Disabling");
    pthread_mutex_lock(&tfa_dev->tfa_lock);
    if (on) {
        if (tfa_dev->tfa_handle->a1 != 0) {
            tfa_dev->tfa_handle->a1 = 0;
        }
    }

    // this implementation requires explicit clock control
    if (on) {
        tfa_clock_on(tfa_dev);
    }

    rc = tfa_dev->tfa_enable(tfa_dev->tfa_handle, on ? 1 : 0);
    if (rc) {
        ALOGE("%s: Failed to %s amplifier device", __func__, on ? "enable" : "disable");
    }

    if (tfa_dev->clock_enabled) {
        tfa_clock_off(tfa_dev);
    }
    pthread_mutex_unlock(&tfa_dev->tfa_lock);

    return rc;
}

/*
 * Initializes the amplifier device and local class data.
 *
 * @return tfa_device_t on success, NULL on error.
 */
tfa_device_t * tfa_device_open() {
    tfa_device_t *tfa_dev;
    int rc;

    ALOGV("Opening amplifier device");

    tfa_dev = (tfa_device_t *) malloc(sizeof(tfa_device_t));
    if (tfa_dev == NULL) {
        ALOGE("%s: Not enough memory to load the lib handle", __func__);
        return NULL;
    }

    // allocate memory for tfa handle
    tfa_dev->tfa_handle = malloc(sizeof(tfa_handle_t));
    if (tfa_dev->tfa_handle == NULL) {
        ALOGE("%s: Not enough memory to load the tfa handle", __func__);
        return NULL;
    }

    rc = load_tfa_lib(tfa_dev);
    if (rc < 0) {
        ALOGE("%s: Failed to load amplifier library", __func__);
        return NULL;
    }

    rc = tfa_dev->tfa_device_open(tfa_dev->tfa_handle, 0);
    if (rc < 0) {
        ALOGE("%s: Failed to open amplifier device", __func__);
        return NULL;
    }

    pthread_mutex_init(&tfa_dev->tfa_lock, (const pthread_mutexattr_t *) NULL);

    rc = tfa_power(tfa_dev, false);
    if (rc < 0) {
        ALOGE("%s: Failed to do initial amplifier powerdown", __func__);
        return NULL;
    }

    // do a full powerup - powerdown cycle and initialize clocks
    tfa_dev->writing = false;
    tfa_dev->clock_enabled = false;
    pthread_mutex_init(&tfa_dev->mutex, NULL);
    pthread_cond_init(&tfa_dev->cond, NULL);

    rc = tfa_power(tfa_dev, true);
    if (rc < 0) {
        ALOGE("%s: Failed to do initial amplifier powerup", __func__);
        return NULL;
    } else {
        rc = tfa_power(tfa_dev, false);
        if (rc < 0) {
            ALOGE("%s: Failed to do initial amplifier powerdown (2)", __func__);
            return NULL;
        }
    }

    return tfa_dev;
}

/*
 * De-Initializes the amplifier device.
 */
void tfa_device_close(tfa_device_t *tfa_dev) {
    ALOGV("%s: Closing amplifier device", __func__);
    tfa_power(tfa_dev, false);

    pthread_mutex_destroy(&tfa_dev->tfa_lock);

    if (tfa_dev->tfa_handle) {
        free(tfa_dev->tfa_handle);
    }

    if (tfa_dev->lib_handle) {
        dlclose(tfa_dev->lib_handle);
    }

    if (tfa_dev) {
        free(tfa_dev);
    }
}
