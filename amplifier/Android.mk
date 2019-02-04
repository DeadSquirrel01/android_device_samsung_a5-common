LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SHARED_LIBRARIES := \
	liblog \
	libutils \
	libcutils \
	libtinyalsa

LOCAL_C_INCLUDES := \
	$(call project-path-for,qcom-audio)/hal/ \
	$(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include \
	external/tinyalsa/include \
	external/tinycompress/include \
	hardware/libhardware/include \
	$(call include-path-for, audio-utils) \
	$(call include-path-for, audio-route) \
	$(call include-path-for, audio-effects)

LOCAL_SRC_FILES := \
	amplifier.c \
	tfa.c

LOCAL_MODULE := audio_amplifier.$(TARGET_BOARD_PLATFORM)
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_MODULE_TAGS := optional
LOCAL_VENDOR_MODULE := true

include $(BUILD_SHARED_LIBRARY)
