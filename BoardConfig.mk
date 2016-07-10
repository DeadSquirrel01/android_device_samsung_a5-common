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

TARGET_NO_BOOTLOADER := true
TARGET_ARCH := arm
ANDROID_COMMON_BUILD_MK = true
CM_VERSION := 12.1

# Platform
TARGET_BOARD_PLATFORM := msm8916
TARGET_BOARD_PLATFORM_GPU := qcom-adreno306
TARGET_BOOTLOADER_BOARD_NAME := MSM8916
#TARGET_USES_QCOM_BSP := true

# Arch
COMMON_GLOBAL_CFLAGS += -DQCOM_HARDWARE
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_VARIANT := generic

TARGET_SPECIFIC_HEADER_PATH := device/samsung/a5ultexx/include

# Kernel
TARGET_KERNEL_HEADER_ARCH    := arm
BOARD_KERNEL_CMDLINE         := console=null androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x3F ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci androidboot.selinux=permissive
BOARD_KERNEL_BASE            := 0x80000000
BOARD_RAMDISK_OFFSET         := 0x02000000
BOARD_KERNEL_TAGS_OFFSET     := 0x01e00000
BOARD_KERNEL_SEPARATED_DT    := true
BOARD_KERNEL_PAGESIZE        := 2048
TARGET_PREBUILT_KERNEL       := device/samsung/a5ultexx/kernel

# Assert
TARGET_OTA_ASSERT_DEVICE := a5ulte,a5ultexx,SM-A500FU

# Partition sizes
TARGET_USERIMAGES_USE_EXT4 := true
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PERSISTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_BOOTIMAGE_PARTITION_SIZE := 13631488
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 15728640
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2411724800
BOARD_PERSISTIMAGE_PARTITION_SIZE := 8388608
BOARD_USERDATAIMAGE_PARTITION_SIZE := 12767444992
BOARD_FLASH_BLOCK_SIZE := 131072

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/samsung/a5ultexx/bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_QCOM := true
BLUETOOTH_HCI_USE_MCT := true

# Custom RIL class
BOARD_RIL_CLASS := ../../../device/samsung/a5ultexx/ril/

# NFC
BOARD_HAVE_NFC := true

# Fonts
EXTENDED_FONT_FOOTPRINT := true

# malloc implementation
MALLOC_IMPL := dlmalloc

# Audio
BOARD_USES_ALSA_AUDIO := true
AUDIO_FEATURE_LOW_LATENCY_PRIMARY := true

# Charger
BOARD_CHARGER_SHOW_PERCENTAGE := true
BOARD_CHARGER_ENABLE_SUSPEND := true
BOARD_HAL_STATIC_LIBRARIES += libhealthd.msm8916

# Enable HW based full disk encryption
TARGET_HW_DISK_ENCRYPTION := true

# Build our own PowerHAL
TARGET_POWERHAL_SET_INTERACTIVE_EXT := $(LOCAL_PATH)/power/power_ext.c
TARGET_POWERHAL_VARIANT := qcom

# Wifi
BOARD_HAS_QCOM_WLAN 		 := true
BOARD_HAS_QCOM_WLAN_SDK 	 := true
BOARD_HOSTAPD_DRIVER 		 := NL80211
BOARD_HOSTAPD_PRIVATE_LIB 	 := lib_driver_cmd_qcwcn
BOARD_WLAN_DEVICE 		 := qcwcn
BOARD_WPA_SUPPLICANT_DRIVER 	 := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_qcwcn
TARGET_PROVIDES_WCNSS_QMI        := true
TARGET_USES_QCOM_WCNSS_QMI 	 := true
TARGET_USES_WCNSS_CTRL 		 := true
WIFI_DRIVER_FW_PATH_AP 		 := "ap"
WIFI_DRIVER_FW_PATH_STA 	 := "sta"
WPA_SUPPLICANT_VERSION 		 := VER_0_8_X

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_QCOM := true
BLUETOOTH_HCI_USE_MCT := true

# Vold
TARGET_USE_CUSTOM_LUN_FILE_PATH := /sys/devices/platform/msm_hsusb/gadget/lun%d/file

# Camera
TARGET_PROVIDES_CAMERA_HAL := true
USE_DEVICE_SPECIFIC_CAMERA := true

# CMHW
BOARD_HARDWARE_CLASS += device/samsung/a5ultexx/cmhw

# Workaround to avoid issues with legacy liblights on QCOM platforms
TARGET_PROVIDES_LIBLIGHT := true

# Qualcomm support
BOARD_USES_QC_TIME_SERVICES := true

# Init
TARGET_PLATFORM_DEVICE_BASE := /devices/soc.0/

# Display
TARGET_CONTINUOUS_SPLASH_ENABLED := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
MAX_EGL_CACHE_KEY_SIZE := 12*1024
MAX_EGL_CACHE_SIZE := 2048*1024
OVERRIDE_RS_DRIVER := libRSDriver_adreno.so
USE_OPENGL_RENDERER := true
TARGET_USES_C2D_COMPOSITION := true

# ANT+
BOARD_ANT_WIRELESS_DEVICE := "vfs-prerelease"

# SELinux
include device/qcom/sepolicy/sepolicy.mk

BOARD_SEPOLICY_DIRS += \
    device/samsung/a5ultexx/sepolicy

BOARD_SEPOLICY_UNION += \
    vold.te \
    file.te \
    wcnss_service.te \
    file_contexts

# Misc.
TARGET_SYSTEM_PROP := device/samsung/a5ultexx/system.prop

# Display
TARGET_USES_ION := true

# Keys
BOARD_HAS_NO_SELECT_BUTTON := true

# Storage
RECOVERY_SDCARD_ON_DATA := true

# Time Zone data
PRODUCT_COPY_FILES += \
bionic/libc/zoneinfo/tzdata:recovery/root/system/usr/share/zoneinfo/tzdata

# Recovery
RECOVERY_VARIANT := carliv
TARGET_RECOVERY_FSTAB := device/samsung/a5ultexx/rootdir/fstab.qcom
BOARD_SUPPRESS_SECURE_ERASE := true

# Carliv Recovery
ifeq ($(RECOVERY_VARIANT),carliv)
TARGET_RECOVERY_DENSITY := xhdpi
VIBRATOR_TIMEOUT_FILE := /sys/devices/virtual/timed_output/vibrator/enable
TARGET_RECOVERY_LCD_BACKLIGHT_PATH := /sys/class/leds/lcd-backlight/brightness
BOARD_USE_CUSTOM_RECOVERY_FONT := \"roboto_15x24.h\"
DEVICE_RESOLUTION := 720x1280
TARGET_RECOVERY_PIXEL_FORMAT := "RGB_565"
BOARD_USE_PROTOCOL_TYPE_B := true
BOARD_INCLUDE_CRYPTO := true
# USB OTG and External Sdcard
TARGET_USES_EXFAT := true
TARGET_USES_NTFS := true
# Qcom
RECOVERY_GRAPHICS_FORCE_USE_LINELENGTH := true
USE_NEW_ION_HEAP := true
endif

# Dex
ifeq ($(HOST_OS),linux)
  ifeq ($(TARGET_BUILD_VARIANT),user)
    ifeq ($(WITH_DEXPREOPT),)
      WITH_DEXPREOPT := true
    endif
  endif
endif
