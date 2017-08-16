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

LOCAL_PATH  := device/samsung/a5-common

# Headers
TARGET_SPECIFIC_HEADER_PATH := $(LOCAL_PATH)/include

# Platform
BOARD_VENDOR                  := samsung
TARGET_BOARD_PLATFORM         := msm8916
TARGET_BOARD_PLATFORM_GPU     := qcom-adreno306
TARGET_BOOTLOADER_BOARD_NAME  := MSM8916
TARGET_NO_BOOTLOADER          := true
BOARD_HAS_DOWNLOAD_MODE       := true

# Arch
TARGET_ARCH             := arm
TARGET_CPU_ABI          := armeabi-v7a
TARGET_CPU_ABI2         := armeabi
TARGET_ARCH_VARIANT     := armv7-a-neon
TARGET_GLOBAL_CFLAGS    += -mfpu=neon -mfloat-abi=softfp
TARGET_GLOBAL_CPPFLAGS  += -mfpu=neon -mfloat-abi=softfp
TARGET_CPU_VARIANT      := cortex-a53
TARGET_CPU_CORTEX_A53   := true

# Kernel
TARGET_KERNEL_ARCH         := arm
BOARD_DTBTOOL_ARGS         := -2
BOARD_CUSTOM_BOOTIMG_MK    := $(LOCAL_PATH)/mkbootimg.mk
BOARD_KERNEL_CMDLINE       := console=null androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x3F ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci androidboot.selinux=permissive
BOARD_KERNEL_BASE          := 0x80000000
BOARD_RAMDISK_OFFSET       := 0x02000000
BOARD_KERNEL_TAGS_OFFSET   := 0x01e00000
BOARD_KERNEL_SEPARATED_DT  := true
BOARD_KERNEL_PAGESIZE      := 2048
TARGET_KERNEL_SOURCE       := kernel/samsung/msm8916
TARGET_KERNEL_CONFIG       := lineageos_a5ultexx_defconfig

# Toolchain
KERNEL_TOOLCHAIN         := $(ANDROID_BUILD_TOP)/prebuilts/gcc/$(HOST_OS)-x86/arm/arm-eabi-4.8/bin
KERNEL_TOOLCHAIN_PREFIX  := arm-eabi-

# Partition sizes
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE    := ext4
BOARD_SYSTEMIMAGE_PARTITION_TYPE     := ext4
BOARD_HAS_LARGE_FILESYSTEM           := true
TARGET_USERIMAGES_USE_EXT4           := true
TARGET_USERIMAGES_USE_F2FS           := true
BOARD_BOOTIMAGE_PARTITION_SIZE       := 13631488
BOARD_RECOVERYIMAGE_PARTITION_SIZE   := 157286400
BOARD_SYSTEMIMAGE_PARTITION_SIZE     := 2516582400
BOARD_PERSISTIMAGE_PARTITION_SIZE    := 8388608
BOARD_CACHEIMAGE_PARTITION_SIZE      := 209715200
BOARD_USERDATAIMAGE_PARTITION_SIZE   := 12775813120
BOARD_FLASH_BLOCK_SIZE               := 131072

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR  := $(LOCAL_PATH)/bluetooth
BOARD_HAVE_BLUETOOTH                         := true
BOARD_HAVE_BLUETOOTH_QCOM                    := true
BLUETOOTH_HCI_USE_MCT                        := true

# RIL
BOARD_GLOBAL_CFLAGS               += -DDISABLE_ASHMEM_TRACKING
BOARD_RIL_CLASS                   := ../../../$(LOCAL_PATH)/ril/
BOARD_PROVIDES_LIBRIL             := true

# Fonts
EXTENDED_FONT_FOOTPRINT  := true

# Audio
#AUDIO_FEATURE_ENABLED_ACDB_LICENSE          := true
#AUDIO_FEATURE_ENABLED_ALAC_OFFLOAD          := true
#AUDIO_FEATURE_ENABLED_ANC_HEADSET           := true
#AUDIO_FEATURE_ENABLED_APE_OFFLOAD           := true
#AUDIO_FEATURE_ENABLED_COMPRESS_VOIP         := true
#AUDIO_FEATURE_ENABLED_DS2_DOLBY_DAP         := true
#AUDIO_FEATURE_ENABLED_EXTN_FLAC_DECODER     := true
#AUDIO_FEATURE_ENABLED_EXTN_FORMATS          := true
#AUDIO_FEATURE_ENABLED_FLAC_OFFLOAD          := true
#AUDIO_FEATURE_ENABLED_FLUENCE               := true
#AUDIO_FEATURE_ENABLED_FM_POWER_OPT          := true
#AUDIO_FEATURE_ENABLED_HFP                   := true
#AUDIO_FEATURE_ENABLED_INCALL_MUSIC          := false
#AUDIO_FEATURE_ENABLED_KPI_OPTIMIZE          := true
#AUDIO_FEATURE_ENABLED_LOW_LATENCY_CAPTURE   := true
#AUDIO_FEATURE_ENABLED_MULTI_VOICE_SESSIONS  := true
#AUDIO_FEATURE_ENABLED_NEW_SAMPLE_RATE       := true
#AUDIO_FEATURE_ENABLED_PCM_OFFLOAD_24        := true
#AUDIO_FEATURE_ENABLED_PROXY_DEVICE          := true
#AUDIO_FEATURE_ENABLED_WFD_CONCURRENCY       := true
#AUDIO_FEATURE_ENABLED_WMA_OFFLOAD           := true
#AUDIO_FEATURE_ENABLED_VOICE_CONCURRENCY     := true
#BOARD_USES_ALSA_AUDIO                       := true
#USE_CUSTOM_AUDIO_POLICY                     := 1
#USE_XML_AUDIO_POLICY_CONF                   := 1
#SNDRV_COMPRESS_SET_NEXT_TRACK_PARAM         := true
AUDIO_FEATURE_ENABLED_INCALL_MUSIC := false
AUDIO_FEATURE_ENABLED_MULTI_VOICE_SESSIONS := true
BOARD_USES_ALSA_AUDIO := true
AUDIO_FEATURE_ENABLED_KPI_OPTIMIZE := true
USE_CUSTOM_AUDIO_POLICY := 1
#USE_XML_AUDIO_POLICY_CONF := 1


# Charger
BOARD_CHARGER_SHOW_PERCENTAGE  := true
BOARD_CHARGER_ENABLE_SUSPEND   := true

# Qualcomm support
BOARD_USES_QCOM_HARDWARE  := true
QCOM_HARDWARE             := true

# Enable QCOM FM feature
TARGET_QCOM_NO_FM_FIRMWARE  := true
BOARD_HAVE_QCOM_FM          := true

# Build our own PowerHAL
TARGET_POWERHAL_VARIANT              := qcom
TARGET_POWERHAL_SET_INTERACTIVE_EXT  := $(LOCAL_PATH)/power/power_ext.c

# Touchscreen
TARGET_TAP_TO_WAKE_NODE  := "/sys/class/sec/sec_touchscreen/wake_gesture"

# Wifi
BOARD_HAS_QCOM_WLAN               := true
BOARD_HOSTAPD_DRIVER              := NL80211
BOARD_HOSTAPD_PRIVATE_LIB         := lib_driver_cmd_qcwcn
BOARD_WLAN_DEVICE                 := qcwcn
BOARD_WPA_SUPPLICANT_DRIVER       := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB  := lib_driver_cmd_qcwcn
TARGET_PROVIDES_WCNSS_QMI         := true
TARGET_USES_QCOM_WCNSS_QMI        := true
TARGET_USES_WCNSS_CTRL            := true
WIFI_DRIVER_MODULE_PATH           := "/system/lib/modules/wlan.ko"
WIFI_DRIVER_MODULE_NAME           := "wlan"
WPA_SUPPLICANT_VERSION            := VER_0_8_X

# Bluetooth
BOARD_HAVE_BLUETOOTH       := true
BOARD_HAVE_BLUETOOTH_QCOM  := true
BLUETOOTH_HCI_USE_MCT      := true

# Vold
TARGET_USE_CUSTOM_LUN_FILE_PATH      := /sys/devices/platform/msm_hsusb/gadget/lun%d/file
BOARD_VOLD_DISC_HAS_MULTIPLE_MAJORS  := true
BOARD_VOLD_MAX_PARTITIONS            := 65

# Camera
TARGET_PROVIDES_CAMERA_HAL     := true
USE_DEVICE_SPECIFIC_CAMERA     := true
TARGET_HAS_LEGACY_CAMERA_HAL1  := true

# Workaround to avoid issues with legacy liblights on QCOM platforms
TARGET_PROVIDES_LIBLIGHT  := true

# Qcom
BOARD_USES_QC_TIME_SERVICES         := true
TARGET_USES_QCOM_BSP                := true
TARGET_PLATFORM_DEVICE_BASE         := /devices/soc.0/
PROTOBUF_SUPPORTED                  := true
HAVE_SYNAPTICS_I2C_RMI4_FW_UPGRADE  := true

# Caf
TARGET_QCOM_MEDIA_VARIANT      := caf-msm8916
TARGET_QCOM_DISPLAY_VARIANT    := caf-msm8916
TARGET_QCOM_AUDIO_VARIANT      := caf-msm8916
TARGET_QCOM_BLUETOOTH_VARIANT  := caf-msm8916

# Media
TARGET_ENABLE_QC_AV_ENHANCEMENTS  := true

# Display
TARGET_CONTINUOUS_SPLASH_ENABLED       := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS        := 3
MAX_EGL_CACHE_KEY_SIZE                 := 12*1024
MAX_EGL_CACHE_SIZE                     := 2048*1024
OVERRIDE_RS_DRIVER                     := libRSDriver_adreno.so
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS  := true

# ANT+
BOARD_ANT_WIRELESS_DEVICE  := "vfs-prerelease"

# SELinux
include device/qcom/sepolicy/sepolicy.mk

BOARD_SEPOLICY_DIRS += \
    $(LOCAL_PATH)/sepolicy

# Misc.
TARGET_SYSTEM_PROP  := $(LOCAL_PATH)/system.prop

# Display
RECOVERY_GRAPHICS_USE_LINELENGTH  := true
TARGET_RECOVERY_PIXEL_FORMAT      := "RGB_565"

# Graphics
TARGET_USES_C2D_COMPOSITION  := true
TARGET_USES_ION              := true

# Keys
BOARD_CUSTOM_RECOVERY_KEYMAPPING  := $(LOCAL_PATH)/recovery/recovery_keys.c
BOARD_HAS_NO_SELECT_BUTTON        := true

# Storage
TARGET_RECOVERY_FSTAB    := $(LOCAL_PATH)/rootdir/etc/fstab.qcom
RECOVERY_SDCARD_ON_DATA  := true

# Misc.
TARGET_RECOVERY_QCOM_RTC_FIX  := true

# Text Relocations
TARGET_NEEDS_PLATFORM_TEXTRELS  := true

# TWRP
TW_NO_REBOOT_BOOTLOADER  := true
TW_HAS_DOWNLOAD_MODE     := true
TW_THEME                 := portrait_hdpi
TW_BRIGHTNESS_PATH       := "/sys/class/leds/lcd-backlight/brightness"
TW_MAX_BRIGHTNESS        := 255
TW_DEFAULT_BRIGHTNESS    := 100
TW_MTP_DEVICE            := /dev/usb_mtp
TW_EXCLUDE_SUPERSU       := true

# Dex
ifeq ($(HOST_OS),linux)
  ifeq ($(TARGET_BUILD_VARIANT),user)
    ifeq ($(WITH_DEXPREOPT),)
      WITH_DEXPREOPT  := true
    endif
  endif
endif
