ifeq ($(TARGET_PROVIDES_CAMERA_HAL),true)

LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

ifeq ($(TARGET_NEED_DISABLE_AUTOFOCUS),true)
    LOCAL_CFLAGS += -DDISABLE_AUTOFOCUS
endif

ifeq ($(TARGET_NEED_DISABLE_FACE_DETECTION),true)
    LOCAL_CFLAGS += -DDISABLE_FACE_DETECTION
endif

ifeq ($(TARGET_NEED_DISABLE_FACE_DETECTION_BOTH_CAMERAS),true)
    LOCAL_CFLAGS += -DDISABLE_FACE_DETECTION_BOTH_CAMERAS
endif

ifeq ($(TARGET_NEED_CAMERA_ZSL),true)
    LOCAL_CFLAGS += -DENABLE_ZSL
endif

ifeq ($(TARGET_NEED_FFC_PICTURE_FIXUP),true)
    LOCAL_CFLAGS += -DFFC_PICTURE_FIXUP
endif

ifeq ($(TARGET_NEED_FFC_VIDEO_FIXUP),true)
    LOCAL_CFLAGS += -DFFC_VIDEO_FIXUP
endif

ifeq ($(TARGET_NEED_SAMSUNG_CAMERA_MODE),true)
    LOCAL_CFLAGS += -DSAMSUNG_CAMERA_MODE
endif

ifeq ($(TARGET_ADD_ISO_MODE_50),true)
    LOCAL_CFLAGS += -DISO_MODE_50
endif

ifeq ($(TARGET_ADD_ISO_MODE_1600),true)
    LOCAL_CFLAGS += -DISO_MODE_1600
endif

ifeq ($(TARGET_ADD_ISO_MODE_HJR),true)
    LOCAL_CFLAGS += -DISO_MODE_HJR
endif

LOCAL_C_INCLUDES := \
    framework/native/include \
    system/media/camera/include

LOCAL_SRC_FILES := \
    CameraWrapper.cpp

LOCAL_SHARED_LIBRARIES := \
    libhardware \
    liblog \
    libcamera_client \
    libgui \
    libhidltransport \
    libutils \
    android.hidl.token@1.0-utils

LOCAL_STATIC_LIBRARIES := \
    libarect

LOCAL_MODULE := camera.$(TARGET_BOARD_PLATFORM)
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_MODULE_TAGS := optional
LOCAL_VENDOR_MODULE := true

include $(BUILD_SHARED_LIBRARY)

endif
