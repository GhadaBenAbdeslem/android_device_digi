LOCAL_PATH := $(call my-dir)

include device/fsl/common/build/kernel.mk
include device/fsl/common/build/uboot.mk
include $(LOCAL_PATH)/AndroidUboot.mk
include $(FSL_PROPRIETARY_PATH)/fsl-proprietary/media-profile/media-profile.mk
include $(FSL_PROPRIETARY_PATH)/fsl-proprietary/sensor/fsl-sensor.mk
