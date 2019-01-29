/*
 * Copyright (C) 2013-2016, The CyanogenMod Project
 * Copyright (C) 2017, The LineageOS Project
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

/**
* @file CameraWrapper.cpp
*
* This file wraps a vendor camera module.
*
*/

//#define LOG_NDEBUG 0

#define LOG_TAG "CameraWrapper"
#include <log/log.h>

#include <camera/Camera.h>
#include <camera/CameraParameters.h>
#include <hardware/camera.h>
#include <hardware/hardware.h>
#include <utils/threads.h>

using namespace android;

static Mutex gCameraWrapperLock;
static camera_module_t* gVendorModule = 0;

static char** fixed_set_params = NULL;

static camera_notify_callback gUserNotifyCb = NULL;
static camera_data_callback gUserDataCb = NULL;
static camera_data_timestamp_callback gUserDataCbTimestamp = NULL;
static camera_request_memory gUserGetMemory = NULL;
static void *gUserCameraDevice = NULL;

static int camera_device_open(const hw_module_t* module, const char* name, hw_device_t** device);
static int camera_get_number_of_cameras(void);
static int camera_get_camera_info(int camera_id, struct camera_info* info);
static int camera_send_command(struct camera_device* device, int32_t cmd, int32_t arg1,
                               int32_t arg2);

static struct hw_module_methods_t camera_module_methods = {
    .open = camera_device_open,
};

camera_module_t HAL_MODULE_INFO_SYM = {
    .common =
        {
            .tag = HARDWARE_MODULE_TAG,
            .module_api_version = CAMERA_MODULE_API_VERSION_1_0,
            .hal_api_version = HARDWARE_HAL_API_VERSION,
            .id = CAMERA_HARDWARE_MODULE_ID,
            .name = "Samsung msm8930 Camera Wrapper",
            .author = "The CyanogenMod Project",
            .methods = &camera_module_methods,
            .dso = NULL,     /* remove compilation warnings */
            .reserved = {0}, /* remove compilation warnings */
        },

    .get_number_of_cameras = camera_get_number_of_cameras,
    .get_camera_info = camera_get_camera_info,
    .set_callbacks = NULL,      /* remove compilation warnings */
    .get_vendor_tag_ops = NULL, /* remove compilation warnings */
    .open_legacy = NULL,        /* remove compilation warnings */
    .set_torch_mode = NULL,     /* remove compilation warnings */
    .init = NULL,               /* remove compilation warnings */
    .reserved = {0},            /* remove compilation warnings */
};

typedef struct wrapper_camera_device {
    camera_device_t base;
    int camera_released;
    int id;
    camera_device_t* vendor;
} wrapper_camera_device_t;

void camera_notify_cb(int32_t msg_type, int32_t ext1, int32_t ext2, void * /*user*/) {
    gUserNotifyCb(msg_type, ext1, ext2, gUserCameraDevice);
}

void camera_data_cb(int32_t msg_type, const camera_memory_t *data, unsigned int index,
        camera_frame_metadata_t *metadata, void * /*user*/) {
    gUserDataCb(msg_type, data, index, metadata, gUserCameraDevice);
}

void camera_data_cb_timestamp(nsecs_t timestamp, int32_t msg_type,
        const camera_memory_t *data, unsigned index, void * /*user*/) {
    gUserDataCbTimestamp(timestamp, msg_type, data, index, gUserCameraDevice);
}

camera_memory_t* camera_get_memory(int fd, size_t buf_size,
        uint_t num_bufs, void * /*user*/) {
    return gUserGetMemory(fd, buf_size, num_bufs, gUserCameraDevice);
}

#define VENDOR_CALL(device, func, ...)                                             \
    ({                                                                             \
        wrapper_camera_device_t* __wrapper_dev = (wrapper_camera_device_t*)device; \
        __wrapper_dev->vendor->ops->func(__wrapper_dev->vendor, ##__VA_ARGS__);    \
    })

#define CAMERA_ID(device) (((wrapper_camera_device_t*)(device))->id)

static int check_vendor_module() {
    int rv = 0;
    ALOGV("%s", __FUNCTION__);

    if (gVendorModule) return 0;

    rv = hw_get_module_by_class("camera", "vendor", (const hw_module_t**)&gVendorModule);
    if (rv) ALOGE("failed to open vendor camera module");
    return rv;
}

const static char* iso_values[] = {
    "auto,"
#ifdef ISO_MODE_50
    "ISO50,"
#endif
#ifdef ISO_MODE_HJR
    "ISO_HJR,"
#endif
    "ISO100,ISO200,ISO400,ISO800"
#ifdef ISO_MODE_1600
    ",ISO1600"
#endif
};

static char* camera_fixup_getparams(int id, const char* settings) {
    CameraParameters params;
    params.unflatten(String8(settings));

#if !LOG_NDEBUG
    ALOGV("%s: original parameters:", __FUNCTION__);
    params.dump();
#endif

    params.set(CameraParameters::KEY_SUPPORTED_ISO_MODES, iso_values[id]);
    params.set(CameraParameters::KEY_PREFERRED_PREVIEW_SIZE_FOR_VIDEO, "1280x720");
    params.set(CameraParameters::KEY_SUPPORTED_SCENE_MODES,
               "auto,asd,action,portrait,landscape,night,night-portrait,theatre,beach,snow,sunset,"
               "steadyphoto,fireworks,sports,party,candlelight,backlight,flowers,AR");

#ifdef FFC_PICTURE_FIXUP
    if (id == 1) {
        params.set(CameraParameters::KEY_SUPPORTED_PICTURE_SIZES,
                   "1392x1392,1280x720,640x480");
    }
#endif
#ifdef FFC_VIDEO_FIXUP
    if (id == 1) {
        if (!params.get(CameraParameters::KEY_SUPPORTED_VIDEO_SIZES)) {
            params.set(CameraParameters::KEY_SUPPORTED_VIDEO_SIZES,
                       "1280x720,640x480,320x240,176x144");
        }
    }
#endif

#ifdef DISABLE_FACE_DETECTION
#ifndef DISABLE_FACE_DETECTION_BOTH_CAMERAS
    /* Disable face detection for front facing camera */
    if (id == 1) {
#endif
        params.remove(CameraParameters::KEY_QC_FACE_RECOGNITION);
        params.remove(CameraParameters::KEY_QC_SUPPORTED_FACE_RECOGNITION);
        params.remove(CameraParameters::KEY_QC_SUPPORTED_FACE_RECOGNITION_MODES);
        params.remove(CameraParameters::KEY_QC_FACE_DETECTION);
        params.remove(CameraParameters::KEY_QC_SUPPORTED_FACE_DETECTION);
        params.remove(CameraParameters::KEY_FACE_DETECTION);
        params.remove(CameraParameters::KEY_SUPPORTED_FACE_DETECTION);
#ifndef DISABLE_FACE_DETECTION_BOTH_CAMERAS
    }
#endif
#endif

#if !LOG_NDEBUG
    ALOGV("%s: fixed parameters:", __FUNCTION__);
    params.dump();
#endif

    String8 strParams = params.flatten();
    char* ret = strdup(strParams.string());

    return ret;
}

static bool wasVideo = false;

static char* camera_fixup_setparams(struct camera_device* device, const char* settings) {
    int id = CAMERA_ID(device);
    CameraParameters params;
    params.unflatten(String8(settings));
    const char* camMode = params.get(CameraParameters::KEY_SAMSUNG_CAMERA_MODE);

    const char* recordingHint = params.get(CameraParameters::KEY_RECORDING_HINT);
    bool isVideo = false;
    if (recordingHint) isVideo = !strcmp(recordingHint, "true");

#if !LOG_NDEBUG
    ALOGV("%s: original parameters:", __FUNCTION__);
    params.dump();
#endif

    if (params.get("iso")) {
        const char* isoMode = params.get(CameraParameters::KEY_ISO_MODE);
        if (strcmp(isoMode, "ISO50") == 0)
            params.set(CameraParameters::KEY_ISO_MODE, "50");
        else if (strcmp(isoMode, "ISO100") == 0)
            params.set(CameraParameters::KEY_ISO_MODE, "100");
        else if (strcmp(isoMode, "ISO200") == 0)
            params.set(CameraParameters::KEY_ISO_MODE, "200");
        else if (strcmp(isoMode, "ISO400") == 0)
            params.set(CameraParameters::KEY_ISO_MODE, "400");
        else if (strcmp(isoMode, "ISO800") == 0)
            params.set(CameraParameters::KEY_ISO_MODE, "800");
        else if (strcmp(isoMode, "ISO1600") == 0)
            params.set(CameraParameters::KEY_ISO_MODE, "1600");
    }

#ifdef SAMSUNG_CAMERA_MODE
    /* Samsung camcorder mode */
    if (id == 1) {
        /* Enable for front camera only */
        if (!(!strcmp(camMode, "1") && !isVideo) || wasVideo) {
            /* Enable only if not already set (Snapchat) but do enable if the setting is left
               over while switching from stills to video */
            if ((!strcmp(params.get(CameraParameters::KEY_PREVIEW_FRAME_RATE), "15") ||
                 (!strcmp(params.get(CameraParameters::KEY_PREVIEW_SIZE), "320x240") &&
                  !strcmp(params.get(CameraParameters::KEY_JPEG_QUALITY), "96"))) &&
                !isVideo) {
                /* Do not set for video chat in Hangouts (Frame rate 15) or Skype (Preview size
                   320x240 and jpeg quality 96 */
            } else {
                /* "Normal case". Required to prevent distorted video and reboots
                   while taking snaps */
                params.set(CameraParameters::KEY_SAMSUNG_CAMERA_MODE, isVideo ? "1" : "0");
            }
            wasVideo = (isVideo || wasVideo);
        }
    } else {
        wasVideo = false;
    }
#endif
#ifdef ENABLE_ZSL
    if (id != 1) {
        params.set(CameraParameters::KEY_ZSL, isVideo ? "off" : "on");
        params.set(CameraParameters::KEY_CAMERA_MODE, isVideo ? "0" : "1");
    }
#endif

#if !LOG_NDEBUG
    ALOGV("%s: fixed parameters:", __FUNCTION__);
    params.dump();
#endif

    String8 strParams = params.flatten();

    if (fixed_set_params[id]) free(fixed_set_params[id]);
    fixed_set_params[id] = strdup(strParams.string());
    char* ret = fixed_set_params[id];

    return ret;
}

/*******************************************************************
 * implementation of camera_device_ops functions
 *******************************************************************/

static int camera_set_preview_window(struct camera_device* device,
                                     struct preview_stream_ops* window) {
    ALOGV("%s->%08X->%08X", __FUNCTION__, (uintptr_t)device,
          (uintptr_t)(((wrapper_camera_device_t*)device)->vendor));

    if (!device) return -EINVAL;

    return VENDOR_CALL(device, set_preview_window, window);
}

static void camera_set_callbacks(struct camera_device* device, camera_notify_callback notify_cb,
                                 camera_data_callback data_cb,
                                 camera_data_timestamp_callback data_cb_timestamp,
                                 camera_request_memory get_memory, void* user) {
    ALOGV("%s->%08X->%08X", __FUNCTION__, (uintptr_t)device,
          (uintptr_t)(((wrapper_camera_device_t*)device)->vendor));

    if (!device) return;

    gUserNotifyCb = notify_cb;
    gUserDataCb = data_cb;
    gUserDataCbTimestamp = data_cb_timestamp;
    gUserGetMemory = get_memory;
    gUserCameraDevice = user;

    VENDOR_CALL(device, set_callbacks, camera_notify_cb, camera_data_cb,
            camera_data_cb_timestamp, camera_get_memory, user);
}

static void camera_enable_msg_type(struct camera_device* device, int32_t msg_type) {
    ALOGV("%s->%08X->%08X", __FUNCTION__, (uintptr_t)device,
          (uintptr_t)(((wrapper_camera_device_t*)device)->vendor));

    if (!device) return;

    VENDOR_CALL(device, enable_msg_type, msg_type);
}

static void camera_disable_msg_type(struct camera_device* device, int32_t msg_type) {
    ALOGV("%s->%08X->%08X", __FUNCTION__, (uintptr_t)device,
          (uintptr_t)(((wrapper_camera_device_t*)device)->vendor));

    if (!device) return;

    VENDOR_CALL(device, disable_msg_type, msg_type);
}

static int camera_msg_type_enabled(struct camera_device* device, int32_t msg_type) {
    ALOGV("%s->%08X->%08X", __FUNCTION__, (uintptr_t)device,
          (uintptr_t)(((wrapper_camera_device_t*)device)->vendor));

    if (!device) return 0;

    return VENDOR_CALL(device, msg_type_enabled, msg_type);
}

static int camera_start_preview(struct camera_device* device) {
    ALOGV("%s->%08X->%08X", __FUNCTION__, (uintptr_t)device,
          (uintptr_t)(((wrapper_camera_device_t*)device)->vendor));

    if (!device) return -EINVAL;

    return VENDOR_CALL(device, start_preview);
}

static void camera_stop_preview(struct camera_device* device) {
    ALOGV("%s->%08X->%08X", __FUNCTION__, (uintptr_t)device,
          (uintptr_t)(((wrapper_camera_device_t*)device)->vendor));

    if (!device) return;

    VENDOR_CALL(device, stop_preview);
}

static int camera_preview_enabled(struct camera_device* device) {
    ALOGV("%s->%08X->%08X", __FUNCTION__, (uintptr_t)device,
          (uintptr_t)(((wrapper_camera_device_t*)device)->vendor));

    if (!device) return -EINVAL;

    return VENDOR_CALL(device, preview_enabled);
}

static int camera_store_meta_data_in_buffers(struct camera_device* device, int enable) {
    ALOGV("%s->%08X->%08X", __FUNCTION__, (uintptr_t)device,
          (uintptr_t)(((wrapper_camera_device_t*)device)->vendor));

    if (!device) return -EINVAL;

    return VENDOR_CALL(device, store_meta_data_in_buffers, enable);
}

static int camera_start_recording(struct camera_device* device) {
    ALOGV("%s->%08X->%08X", __FUNCTION__, (uintptr_t)device,
          (uintptr_t)(((wrapper_camera_device_t*)device)->vendor));

    if (!device) return EINVAL;

    return VENDOR_CALL(device, start_recording);
}

static void camera_stop_recording(struct camera_device* device) {
    ALOGV("%s->%08X->%08X", __FUNCTION__, (uintptr_t)device,
          (uintptr_t)(((wrapper_camera_device_t*)device)->vendor));

    if (!device) return;

    VENDOR_CALL(device, stop_recording);
}

static int camera_recording_enabled(struct camera_device* device) {
    ALOGV("%s->%08X->%08X", __FUNCTION__, (uintptr_t)device,
          (uintptr_t)(((wrapper_camera_device_t*)device)->vendor));

    if (!device) return -EINVAL;

    return VENDOR_CALL(device, recording_enabled);
}

static void camera_release_recording_frame(struct camera_device* device, const void* opaque) {
    ALOGV("%s->%08X->%08X", __FUNCTION__, (uintptr_t)device,
          (uintptr_t)(((wrapper_camera_device_t*)device)->vendor));

    if (!device) return;

    VENDOR_CALL(device, release_recording_frame, opaque);
}

static int camera_auto_focus(struct camera_device* device) {
    ALOGV("%s->%08X->%08X", __FUNCTION__, (uintptr_t)device,
          (uintptr_t)(((wrapper_camera_device_t*)device)->vendor));

    if (!device) return -EINVAL;

    return VENDOR_CALL(device, auto_focus);
}

static int camera_cancel_auto_focus(struct camera_device* device) {
    int ret = 0;

    ALOGV("%s->%08X->%08X", __FUNCTION__, (uintptr_t)device,
          (uintptr_t)(((wrapper_camera_device_t*)device)->vendor));

    if (!device) return -EINVAL;

/* APEXQ/EXPRESS: Calling cancel_auto_focus causes the camera to crash for unknown reasons.
 * Disabling it has no adverse effect. For others, only call cancel_auto_focus when the
 * preview is enabled. This is needed so some 3rd party camera apps don't lock up. */
#ifndef DISABLE_AUTOFOCUS
    if (camera_preview_enabled(device)) ret = VENDOR_CALL(device, cancel_auto_focus);
#endif

    return ret;
}

static int camera_take_picture(struct camera_device* device) {
    ALOGV("%s->%08X->%08X", __FUNCTION__, (uintptr_t)device,
          (uintptr_t)(((wrapper_camera_device_t*)device)->vendor));

    if (!device) return -EINVAL;

    return VENDOR_CALL(device, take_picture);
}

static int camera_cancel_picture(struct camera_device* device) {
    ALOGV("%s->%08X->%08X", __FUNCTION__, (uintptr_t)device,
          (uintptr_t)(((wrapper_camera_device_t*)device)->vendor));

    if (!device) return -EINVAL;

    return VENDOR_CALL(device, cancel_picture);
}

static int camera_set_parameters(struct camera_device* device, const char* params) {
    ALOGV("%s->%08X->%08X", __FUNCTION__, (uintptr_t)device,
          (uintptr_t)(((wrapper_camera_device_t*)device)->vendor));

    if (!device) return -EINVAL;

    char* tmp = NULL;
    tmp = camera_fixup_setparams(device, params);

    int ret = VENDOR_CALL(device, set_parameters, tmp);
    return ret;
}

static char* camera_get_parameters(struct camera_device* device) {
    ALOGV("%s->%08X->%08X", __FUNCTION__, (uintptr_t)device,
          (uintptr_t)(((wrapper_camera_device_t*)device)->vendor));

    if (!device) return NULL;

    char* params = VENDOR_CALL(device, get_parameters);

    char* tmp = camera_fixup_getparams(CAMERA_ID(device), params);
    VENDOR_CALL(device, put_parameters, params);
    params = tmp;

    return params;
}

static void camera_put_parameters(struct camera_device* device, char* params) {
    ALOGV("%s->%08X->%08X", __FUNCTION__, (uintptr_t)device,
          (uintptr_t)(((wrapper_camera_device_t*)device)->vendor));

    if (params) free(params);
}

static int camera_send_command(struct camera_device* device, int32_t cmd, int32_t arg1,
                               int32_t arg2) {
    ALOGV("%s->%08X->%08X", __FUNCTION__, (uintptr_t)device,
          (uintptr_t)(((wrapper_camera_device_t*)device)->vendor));

    if (!device) return -EINVAL;

    return VENDOR_CALL(device, send_command, cmd, arg1, arg2);
}

static void camera_release(struct camera_device* device) {
    wrapper_camera_device_t* wrapper_dev = NULL;

    ALOGV("%s->%08X->%08X", __FUNCTION__, (uintptr_t)device,
          (uintptr_t)(wrapper_dev->vendor));

    if (!device) return;

    VENDOR_CALL(device, release);

    wrapper_dev->camera_released = true;
}

static int camera_dump(struct camera_device* device, int fd) {
    ALOGV("%s->%08X->%08X", __FUNCTION__, (uintptr_t)device,
          (uintptr_t)(((wrapper_camera_device_t*)device)->vendor));

    if (!device) return -EINVAL;

    return VENDOR_CALL(device, dump, fd);
}

extern "C" void heaptracker_free_leaked_memory(void);

static int camera_device_close(hw_device_t* device) {
    int ret = 0;
    wrapper_camera_device_t* wrapper_dev = NULL;

    ALOGV("%s", __FUNCTION__);

    Mutex::Autolock lock(gCameraWrapperLock);

    if (!device) {
        ret = -EINVAL;
        goto done;
    }

    for (int i = 0; i < camera_get_number_of_cameras(); i++) {
        if (fixed_set_params[i]) free(fixed_set_params[i]);
    }

    wrapper_dev = (wrapper_camera_device_t*)device;

    if (!wrapper_dev->camera_released) {
        ALOGI("%s: releasing camera device with id %d", __FUNCTION__,
                wrapper_dev->id);

        VENDOR_CALL(wrapper_dev, release);

        wrapper_dev->camera_released = true;
    }

    wrapper_dev->vendor->common.close((hw_device_t*)wrapper_dev->vendor);
    if (wrapper_dev->base.ops) free(wrapper_dev->base.ops);
    free(wrapper_dev);
done:
#ifdef HEAPTRACKER
    heaptracker_free_leaked_memory();
#endif
    return ret;
}

/*******************************************************************
 * implementation of camera_module functions
 *******************************************************************/

/* open device handle to one of the cameras
 *
 * assume camera service will keep singleton of each camera
 * so this function will always only be called once per camera instance
 */

static int camera_device_open(const hw_module_t* module, const char* name, hw_device_t** device) {
    int rv = 0;
    int num_cameras = 0;
    int cameraid;
    wrapper_camera_device_t* camera_device = NULL;
    camera_device_ops_t* camera_ops = NULL;
    wasVideo = false;

    Mutex::Autolock lock(gCameraWrapperLock);

    ALOGV("%s", __FUNCTION__);

    if (name != NULL) {
        if (check_vendor_module()) return -EINVAL;

        cameraid = atoi(name);
        num_cameras = gVendorModule->get_number_of_cameras();

        fixed_set_params = (char**)malloc(sizeof(char*) * num_cameras);
        if (!fixed_set_params) {
            ALOGE("parameter memory allocation fail");
            rv = -ENOMEM;
            goto fail;
        }
        memset(fixed_set_params, 0, sizeof(char*) * num_cameras);

        if (cameraid > num_cameras) {
            ALOGE(
                "camera service provided cameraid out of bounds, "
                "cameraid = %d, num supported = %d",
                cameraid, num_cameras);
            rv = -EINVAL;
            goto fail;
        }

        camera_device = (wrapper_camera_device_t*)malloc(sizeof(*camera_device));
        if (!camera_device) {
            ALOGE("camera_device allocation fail");
            rv = -ENOMEM;
            goto fail;
        }
        memset(camera_device, 0, sizeof(*camera_device));
        camera_device->camera_released = false;
        camera_device->id = cameraid;

        rv = gVendorModule->common.methods->open((const hw_module_t*)gVendorModule, name,
                                                 (hw_device_t**)&(camera_device->vendor));
        if (rv) {
            ALOGE("vendor camera open fail");
            goto fail;
        }
        ALOGV("%s: got vendor camera device 0x%08X", __FUNCTION__,
              (uintptr_t)(camera_device->vendor));

        camera_ops = (camera_device_ops_t*)malloc(sizeof(*camera_ops));
        if (!camera_ops) {
            ALOGE("camera_ops allocation fail");
            rv = -ENOMEM;
            goto fail;
        }

        memset(camera_ops, 0, sizeof(*camera_ops));

        camera_device->base.common.tag = HARDWARE_DEVICE_TAG;
        camera_device->base.common.version = HARDWARE_DEVICE_API_VERSION(1, 0);
        camera_device->base.common.module = (hw_module_t*)(module);
        camera_device->base.common.close = camera_device_close;
        camera_device->base.ops = camera_ops;

        camera_ops->set_preview_window = camera_set_preview_window;
        camera_ops->set_callbacks = camera_set_callbacks;
        camera_ops->enable_msg_type = camera_enable_msg_type;
        camera_ops->disable_msg_type = camera_disable_msg_type;
        camera_ops->msg_type_enabled = camera_msg_type_enabled;
        camera_ops->start_preview = camera_start_preview;
        camera_ops->stop_preview = camera_stop_preview;
        camera_ops->preview_enabled = camera_preview_enabled;
        camera_ops->store_meta_data_in_buffers = camera_store_meta_data_in_buffers;
        camera_ops->start_recording = camera_start_recording;
        camera_ops->stop_recording = camera_stop_recording;
        camera_ops->recording_enabled = camera_recording_enabled;
        camera_ops->release_recording_frame = camera_release_recording_frame;
        camera_ops->auto_focus = camera_auto_focus;
        camera_ops->cancel_auto_focus = camera_cancel_auto_focus;
        camera_ops->take_picture = camera_take_picture;
        camera_ops->cancel_picture = camera_cancel_picture;
        camera_ops->set_parameters = camera_set_parameters;
        camera_ops->get_parameters = camera_get_parameters;
        camera_ops->put_parameters = camera_put_parameters;
        camera_ops->send_command = camera_send_command;
        camera_ops->release = camera_release;
        camera_ops->dump = camera_dump;

        *device = &camera_device->base.common;
    }

    return rv;

fail:
    if (camera_device) {
        free(camera_device);
        camera_device = NULL;
    }
    if (camera_ops) {
        free(camera_ops);
        camera_ops = NULL;
    }
    *device = NULL;
    return rv;
}

static int camera_get_number_of_cameras(void) {
    ALOGV("%s", __FUNCTION__);
    if (check_vendor_module()) return 0;
    return gVendorModule->get_number_of_cameras();
}

static int camera_get_camera_info(int camera_id, struct camera_info* info) {
    ALOGV("%s", __FUNCTION__);
    if (check_vendor_module()) return 0;
    return gVendorModule->get_camera_info(camera_id, info);
}
