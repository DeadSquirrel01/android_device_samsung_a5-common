# Copyright (C) 2015 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# Also get non-open-source specific aspects if available
$(call inherit-product-if-exists, vendor/samsung/a5-common/a5-common-vendor.mk)

# Common overlay
DEVICE_PACKAGE_OVERLAYS += device/samsung/a5-common/overlay-lineage

# Permissions
PRODUCT_COPY_FILES += \
    external/ant-wireless/antradio-library/com.dsi.ant.antradio_library.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.dsi.ant.antradio_library.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/base/nfc-extras/com.android.nfc_extras.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.android.nfc_extras.xml \
    frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml \
    frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.live_wallpaper.xml

# DT
PRODUCT_HOST_PACKAGES += \
    dtbToolLineage

# Touch issue workaround
PRODUCT_PACKAGES += \
    InputDisabler

# Shims
PRODUCT_PACKAGES += \
    libizat_core_shim \
    libsec-ril_shim

# Radio
PRODUCT_PACKAGES += \
    curl \
    libbson \
    libcurl \
    tcpdump \
    libkeyutils \
    librmnetctl \
    rmnetcli \
    libcnefeatureconfig \
    macloader

# Audio
PRODUCT_PACKAGES += \
    audio.a2dp.default \
    audio.primary.msm8916 \
    audio.primary.default \
    audio_amplifier.msm8916 \
    audio.r_submix.default \
    audio.usb.default \
    libaudioresampler \
    libqcompostprocbundle \
    libqcomvisualizer \
    libqcomvoiceprocessing \
    android.hardware.audio@2.0-impl \
    android.hardware.audio@2.0-service \
    android.hardware.audio.effect@2.0-impl \
    android.hardware.audio.effect@2.0-service \
    android.hardware.broadcastradio@1.0-impl \
    android.hardware.soundtrigger@2.0-impl

# TinyAlsa utils
PRODUCT_PACKAGES += \
    tinyplay \
    tinycap \
    tinymix \
    tinypcminfo \
    libtinycompress

# Display
PRODUCT_PACKAGES += \
    gralloc.msm8916 \
    hwcomposer.msm8916 \
    memtrack.msm8916 \
    copybit.msm8916 \
    libtinyxml \
    libgenlock \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service

# LiveDisplay
PRODUCT_PACKAGES += \
    vendor.lineage.livedisplay@2.0-service.samsung-qcom

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-impl \
    android.hardware.drm@1.0-service

# RenderScript HAL
PRODUCT_PACKAGES += \
    android.hardware.renderscript@1.0-impl

# Power
PRODUCT_PACKAGES += \
    android.hardware.power@1.1-service-qti

# Thermal
PRODUCT_PACKAGES += \
    android.hardware.thermal@1.0-impl \
    android.hardware.thermal@1.0-service

# Lights
PRODUCT_PACKAGES += \
    lights.msm8916 \
    android.hardware.light@2.0-impl \
    android.hardware.light@2.0-service

# Sensors
PRODUCT_PACKAGES += \
    sensors.msm8916 \
    android.hardware.sensors@1.0-impl

# Keystore
PRODUCT_PACKAGES += \
    keystore.msm8916

# Keymaster
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service

# Camera
PRODUCT_PACKAGES += \
    Camera2 \
    libmm-qcamera \
    camera.msm8916 \
    android.hardware.camera.provider@2.4-impl \
    camera.device@1.0-impl

PRODUCT_PROPERTY_OVERRIDES += \
    media.stagefright.legacyencoder=true \
    media.stagefright.less-secure=true

# GPS HAL
PRODUCT_PACKAGES += \
    gps.msm8916

# GNSS HAL
PRODUCT_PACKAGES += \
    android.hardware.gnss@1.0-impl \
    android.hardware.gnss@1.0-service

# Location
PRODUCT_PACKAGES += \
    com.android.location.provider \
    com.android.location.provider.xml

# USB HAL
PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service.basic

# OMX
PRODUCT_PACKAGES += \
    libextmedia_jni \
    libqcmediaplayer \
    libOmxAacEnc \
    libOmxAmrEnc \
    libOmxCore \
    libOmxEvrcEnc \
    libOmxQcelp13Enc \
    libOmxVdec \
    libOmxVenc \
    libOmxVidcCommon \
    libstagefrighthw

# Misc. libs
PRODUCT_PACKAGES += \
    libboringssl-compat

# FM
PRODUCT_PACKAGES += \
    FM2 \
    libqcomfm_jni \
    qcom.fmradio

# IPv6 tethering
PRODUCT_PACKAGES += \
    ebtables \
    ethertypes \
    libebtc

PRODUCT_PACKAGES += \
    init.qcom.bt.sh

PRODUCT_PACKAGES += \
    fstab.qcom \
    init.qcom.rc \
    init.qcom.usb.rc \
    ueventd.rc \
    init.qcom.post_boot.sh \
    init.carrier.rc \
    init.class_main.sh \
    init.qcom.bt.sh \
    init.qcom.uicc.sh \
    init.qcom.early_boot.sh \
    init.qcom.usb.sh \
    init.qcom.fm.sh \
    init.qcom.sh \
    init.recovery.qcom.rc

# Filesystem
PRODUCT_PACKAGES += \
    fsck.f2fs \
    mkfs.f2fs \
    fs_config_files

# Live Wallpapers
PRODUCT_PACKAGES += \
    LiveWallpapers \
    LiveWallpapersPicker \
    VisualizationWallpapers \
    librs_jni

# WCNSS service daemon
PRODUCT_PACKAGES += \
    libwcnss_qmi \
    wcnss_service

# ANT+
PRODUCT_PACKAGES += \
   AntHalService \
   com.dsi.ant.antradio_library \
   libantradio

# Misc
PRODUCT_PACKAGES += \
    libxml2

# Vibrator
PRODUCT_PACKAGES += \
    android.hardware.vibrator@1.0-impl \
    android.hardware.vibrator@1.0-service

 # Trust HAL
PRODUCT_PACKAGES += \
    vendor.lineage.trust@1.0-service

# NFC packages
PRODUCT_PACKAGES += \
    libnfc_nci \
    NfcNci \
    Tag \
    com.android.nfc_extras \
    android.hardware.nfc@1.0-impl \
    android.hardware.nfc@1.0-service

# NFC configuration
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/nfc/libnfc-sec.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-nci.conf \
    $(LOCAL_PATH)/nfc/libnfc-sec-hal.conf:system/etc/libnfc-sec-hal.conf \
    $(LOCAL_PATH)/nfc/nfcee_access.xml:system/etc/nfcee_access.xml

# Audio configuration
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    $(LOCAL_PATH)/audio/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml \
    $(LOCAL_PATH)/audio/audio_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_platform_info.xml

# Audio calibration
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio/acdb/Bluetooth_cal.acdb:system/etc/Bluetooth_cal.acdb \
    $(LOCAL_PATH)/audio/acdb/General_cal.acdb:system/etc/General_cal.acdb \
    $(LOCAL_PATH)/audio/acdb/Global_cal.acdb:system/etc/Global_cal.acdb \
    $(LOCAL_PATH)/audio/acdb/Handset_cal.acdb:system/etc/Handset_cal.acdb \
    $(LOCAL_PATH)/audio/acdb/Hdmi_cal.acdb:system/etc/Hdmi_cal.acdb \
    $(LOCAL_PATH)/audio/acdb/Headset_cal.acdb:system/etc/Headset_cal.acdb \
    $(LOCAL_PATH)/audio/acdb/Speaker_cal.acdb:system/etc/Speaker_cal.acdb \
    $(LOCAL_PATH)/audio/Tfa9895.cnt:system/etc/Tfa9895.cnt

# Media Profile
PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_telephony.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_telephony.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video_le.xml \
    $(LOCAL_PATH)/media/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
    $(LOCAL_PATH)/media/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    $(LOCAL_PATH)/media/media_profiles_V1_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml

# Media seccomp policy
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/seccomp/mediacodec.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    $(LOCAL_PATH)/seccomp/mediaextractor.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy

# Camera
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/camera/external_camera_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/external_camera_config.xml

# Keylayouts
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/keylayout/gpio-keys.kl:system/usr/keylayout/gpio-keys.kl \
    $(LOCAL_PATH)/keylayout/sec_touchkey.kl:system/usr/keylayout/sec_touchkey.kl \
    $(LOCAL_PATH)/keylayout/Synaptics_RMI4_TouchPad_Sensor.idc:system/usr/idc/Synaptics_RMI4_TouchPad_Sensor.idc \
    $(LOCAL_PATH)/keylayout/Synaptics_HID_TouchPad.idc:system/usr/idc/Synaptics_HID_TouchPad.idc

# XML Audio configuration files
PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/usb_audio_policy_configuration.xml \
    $(LOCAL_PATH)/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/audio_policy_configuration.xml

# GPS config
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/gps.conf:system/etc/gps.conf \
    $(LOCAL_PATH)/configs/sap.conf:system/etc/sap.conf \
    $(LOCAL_PATH)/configs/flp.conf:system/etc/flp.conf \
    $(LOCAL_PATH)/configs/izat.conf:system/etc/izat.conf

# GPS/location security configuration file
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/sec_config:system/etc/sec_config

# Prima opensource driver files
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/prima/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini \
    $(LOCAL_PATH)/prima/WCNSS_qcom_wlan_nv.bin:system/etc/wifi/WCNSS_qcom_wlan_nv.bin \

# Wi-Fi
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/wifi/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
    $(LOCAL_PATH)/configs/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf

# Thermal
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/thermal/thermal-engine.conf:$(TARGET_COPY_OUT_VENDOR)/etc/thermal-engine.conf

# Bluetooth
PRODUCT_PACKAGES += \
    libbt-vendor \
    android.hardware.bluetooth@1.0-impl \
    android.hardware.bluetooth@1.0-service

PRODUCT_PROPERTY_OVERRIDES += \
    qcom.bluetooth.soc=smd \
    ro.qualcomm.bt.hci_transport=smd \
    persist.bluetooth.bluetooth_audio_hal.disabled=true

# WiFi
PRODUCT_PACKAGES += \
    wcnss_service \
    hostapd \
    hostapd_cli \
    wificond \
    wifilogd \
    android.hardware.wifi@1.0-service

# WPA supplicant
PRODUCT_PACKAGES += \
    dhcpcd.conf \
    libwpa_client \
    wpa_supplicant \
    wpa_supplicant.conf

# Frameworks
PRODUCT_ENFORCE_RRO_TARGETS := \
    framework-res

# For TWRP
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/twrp.fstab:recovery/root/etc/twrp.fstab

# HIDL
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/hidl/manifest.xml:$(TARGET_COPY_OUT_VENDOR)/manifest.xml

# We have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

# Common qcom
$(call inherit-product, device/samsung/qcom-common/qcom-common.mk)

# Dalvik heap config
$(call inherit-product, frameworks/native/build/phone-xhdpi-2048-dalvik-heap.mk)
