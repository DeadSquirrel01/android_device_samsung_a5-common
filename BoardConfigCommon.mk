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

#
# This file sets variables that control the way modules are built
# thorughout the system. It should not be used to conditionally
# disable makefiles (the proper mechanism to control what gets
# included in a build is to use PRODUCT_PACKAGES in a product
# definition file).
#

# inherit from qcom-common
-include device/samsung/qcom-common/BoardConfigCommon.mk

LOCAL_PATH := device/samsung/a5-common
BUILD_TOP  := $(shell pwd)

TARGET_SPECIFIC_HEADER_PATH  := device/samsung/a5-common/include

# Platform
TARGET_BOARD_PLATFORM        := msm8916
TARGET_BOARD_PLATFORM_GPU    := qcom-adreno306
TARGET_BOOTLOADER_BOARD_NAME := MSM8916

# Arch
TARGET_CPU_VARIANT          := cortex-a53
TARGET_CPU_CORTEX_A53       := true

# Kernel
TARGET_KERNEL_ARCH            := arm
TARGET_LINUX_KERNEL_VERSION   := 3.10
BOARD_CUSTOM_BOOTIMG          := true
BOARD_CUSTOM_BOOTIMG_MK       := hardware/samsung/mkbootimg.mk
BOARD_DTBTOOL_ARGS            := -2
BOARD_KERNEL_CMDLINE          := console=null androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x3F ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci androidboot.selinux=enforcing
BOARD_KERNEL_BASE             := 0x80000000
BOARD_RAMDISK_OFFSET          := 0x02000000
BOARD_KERNEL_TAGS_OFFSET      := 0x01e00000
BOARD_KERNEL_SEPARATED_DT     := true
BOARD_KERNEL_PAGESIZE         := 2048
TARGET_KERNEL_SOURCE          := kernel/samsung/msm8916
TARGET_KERNEL_CONFIG          := msm8916_sec_defconfig
TARGET_KERNEL_VARIANT_CONFIG  := msm8916_sec_a5u_eur_defconfig
TARGET_KERNEL_SELINUX_CONFIG  := selinux_defconfig
BOARD_KERNEL_IMAGE_NAME       := zImage

# Toolchain
KERNEL_TOOLCHAIN            := $(BUILD_TOP)/prebuilts/gcc/$(HOST_OS)-x86/arm/arm-eabi-4.8/bin
KERNEL_TOOLCHAIN_PREFIX     := arm-eabi-

# Partition sizes and filesystems
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE   := ext4
BOARD_SYSTEMIMAGE_PARTITION_TYPE    := ext4
BOARD_HAS_LARGE_FILESYSTEM          := true
TARGET_USERIMAGES_USE_EXT4          := true
TARGET_USERIMAGES_USE_F2FS          := true
TARGET_USES_MKE2FS                  := true
TARGET_EXFAT_DRIVER                 := sdfat
BOARD_BOOTIMAGE_PARTITION_SIZE      := 13631488
BOARD_RECOVERYIMAGE_PARTITION_SIZE  := 167286400
BOARD_SYSTEMIMAGE_PARTITION_SIZE    := 2000000000
BOARD_PERSISTIMAGE_PARTITION_SIZE   := 8388608
BOARD_CACHEIMAGE_PARTITION_SIZE     := 209715200
BOARD_USERDATAIMAGE_PARTITION_SIZE  := 12775813120
BOARD_FLASH_BLOCK_SIZE              := 131072
TARGET_FS_CONFIG_GEN                := $(LOCAL_PATH)/config.fs

# Root folders
BOARD_ROOT_EXTRA_FOLDERS := \
    firmware \
    firmware-modem \
    efs \
    misc \
    persist

# APEX image
DEXPREOPT_GENERATE_APEX_IMAGE := true

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/samsung/a5-common/bluetooth
BOARD_HAVE_BLUETOOTH                        := true
BOARD_HAVE_BLUETOOTH_QCOM                   := true
BLUETOOTH_HCI_USE_MCT                       := true

# RIL
BOARD_PROVIDES_LIBRIL                  := true
BOARD_MODEM_TYPE                       := xmm7260
TARGET_NEEDS_NETD_DIRECT_CONNECT_RULE  := true

# GPS
TARGET_NO_RPC            := true
USE_DEVICE_SPECIFIC_GPS  := true

# Fonts
EXTENDED_FONT_FOOTPRINT          := true

# Audio
BOARD_USES_ALSA_AUDIO                := true
USE_CUSTOM_AUDIO_POLICY              := 1
BOARD_USES_GENERIC_AUDIO             := true
TARGET_USES_QCOM_MM_AUDIO            := true
USE_XML_AUDIO_POLICY_CONF            := 1

# Charger
BOARD_CHARGER_SHOW_PERCENTAGE    := true
BOARD_CHARGER_ENABLE_SUSPEND     := true

# Enable QCOM FM feature
BOARD_HAVE_QCOM_FM                  := true
AUDIO_FEATURE_ENABLED_FM            := true
AUDIO_FEATURE_ENABLED_FM_POWER_OPT  := true

# Build our own PowerHAL
TARGET_POWERHAL_SET_INTERACTIVE_EXT := $(LOCAL_PATH)/power/power_ext.c

# Touchscreen
TARGET_TAP_TO_WAKE_NODE := "/sys/class/sec/sec_touchscreen/wake_gesture"

# Wifi
BOARD_HAS_QCOM_WLAN               := true
BOARD_HOSTAPD_DRIVER              := NL80211
BOARD_HOSTAPD_PRIVATE_LIB         := lib_driver_cmd_qcwcn
BOARD_WLAN_DEVICE                 := qcwcn
BOARD_WPA_SUPPLICANT_DRIVER	  := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB  := lib_driver_cmd_qcwcn
TARGET_PROVIDES_WCNSS_QMI         := true
TARGET_USES_QCOM_WCNSS_QMI        := true
WIFI_DRIVER_FW_PATH_STA           := "sta"
WIFI_DRIVER_FW_PATH_AP            := "ap"
WPA_SUPPLICANT_VERSION            := VER_0_8_X
TARGET_DISABLE_WCNSS_CONFIG_COPY  := true

# Bluetooth
BOARD_HAVE_BLUETOOTH       := true
BOARD_HAVE_BLUETOOTH_QCOM  := true
BLUETOOTH_HCI_USE_MCT      := true

# Vold
TARGET_USE_CUSTOM_LUN_FILE_PATH      := /sys/devices/platform/msm_hsusb/gadget/lun%d/file
BOARD_VOLD_DISC_HAS_MULTIPLE_MAJORS  := true
BOARD_VOLD_MAX_PARTITIONS            := 65

# Camera
TARGET_HAS_LEGACY_CAMERA_HAL1                      := true
TARGET_NEEDS_LEGACY_CAMERA_HAL1_DYN_NATIVE_HANDLE  := true
TARGET_PROVIDES_CAMERA_HAL                         := true
TARGET_SPECIFIC_CAMERA_PARAMETER_LIBRARY           := camera_parameters_samsung_msm8916
USE_DEVICE_SPECIFIC_CAMERA                         := true
TARGET_NEED_CAMERA_ZSL                             := true

# LineageHW
BOARD_HARDWARE_CLASS += device/samsung/a5-common/lineagehw

# Workaround to avoid issues with legacy liblights on QCOM platforms
TARGET_PROVIDES_LIBLIGHT := true

# Qcom
BOARD_USES_QC_TIME_SERVICES         := true
TARGET_USES_QCOM_BSP                := true
TARGET_PLATFORM_DEVICE_BASE         := /devices/soc.0/
PROTOBUF_SUPPORTED                  := true
HAVE_SYNAPTICS_I2C_RMI4_FW_UPGRADE  := true

# Media
TARGET_USES_MEDIA_EXTENSIONS  := true
TARGET_QCOM_MEDIA_VARIANT     := caf

# Display
TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS  := 0x02000000
TARGET_CONTINUOUS_SPLASH_ENABLED         := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS          := 3
MAX_EGL_CACHE_KEY_SIZE                   := 12*1024
MAX_EGL_CACHE_SIZE                       := 2048*1024
OVERRIDE_RS_DRIVER                       := libRSDriver_adreno.so
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS    := true
TARGET_USES_GRALLOC1                     := true
TARGET_USES_NEW_ION_API                  := true

# ANT+
BOARD_ANT_WIRELESS_DEVICE := "vfs-prerelease"

# Binder
TARGET_USES_64_BIT_BINDER  := true

# SDK
TARGET_PROCESS_SDK_VERSION_OVERRIDE += \
    /system/bin/mediaserver=22 \
    /system/bin/mm-qcamera-daemon=22 \
    /system/vendor/bin/hw/rild=27

# SELinux
include device/qcom/sepolicy-legacy/sepolicy.mk

BOARD_SEPOLICY_DIRS += \
    device/samsung/a5-common/sepolicy

# Misc.
TARGET_SYSTEM_PROP := device/samsung/a5-common/system.prop

# Display
RECOVERY_GRAPHICS_USE_LINELENGTH  := true
TARGET_RECOVERY_PIXEL_FORMAT      := "RGB_565"

# Keys
BOARD_CUSTOM_RECOVERY_KEYMAPPING  := ../../device/samsung/a5-common/recovery/recovery_keys.c
BOARD_HAS_NO_SELECT_BUTTON        := true

# Storage
TARGET_RECOVERY_FSTAB   := device/samsung/a5-common/rootdir/etc/fstab.qcom
RECOVERY_SDCARD_ON_DATA := true

# Misc.
TARGET_RECOVERY_QCOM_RTC_FIX := true

# Ignore Dependencies
ALLOW_MISSING_DEPENDENCIES := true

# Shims
TARGET_LD_SHIM_LIBS := \
    /system/lib/libcrypto.so|libboringssl-compat.so \
    /system/lib/libsec-ril.so|libsec-ril_shim.so \
    /system/lib/libsec-ril-dsds.so|libsec-ril_shim.so \
    /system/vendor/lib/libizat_core.so|libizat_core_shim.so

# Encryption
TARGET_KEYMASTER_SKIP_WAITING_FOR_QSEE := true

# TWRP
ifeq ($(RECOVERY_VARIANT),twrp)
TW_NO_REBOOT_BOOTLOADER := true
TW_HAS_DOWNLOAD_MODE    := true
TW_THEME                := portrait_hdpi
TW_BRIGHTNESS_PATH      := "/sys/class/leds/lcd-backlight/brightness"
TW_MAX_BRIGHTNESS       := 255
TW_DEFAULT_BRIGHTNESS   := 100
TW_MTP_DEVICE           := "/dev/usb_mtp_gadget"
TW_EXCLUDE_SUPERSU      := true
endif

# Dex
WITH_DEXPREOPT := true
WITH_DEXPREOPT_BOOT_IMG_AND_SYSTEM_SERVER_ONLY := true
