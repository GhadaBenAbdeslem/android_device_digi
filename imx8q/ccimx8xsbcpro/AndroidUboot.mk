# uboot.imx in android combine scfw.bin and uboot.bin
MAKE += SHELL=/bin/bash
ATF_TOOLCHAIN_ABS := $(realpath prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64/aarch64-linux-android-4.9/bin)
ATF_CROSS_COMPILE := $(ATF_TOOLCHAIN_ABS)/aarch64-linux-androidkernel-

# Make a second copy of the final artifcact removing the target from the name to avoid non-bootable U-Boots.
define build_imx_uboot
	MKIMAGE_PLATFORM="iMX8QX"; \
	SCFW_PLATFORM="8qx"; \
	ATF_PLATFORM="imx8qx"; \
	UBOOT_PLATFORM=$2; \
	$(MAKE) -C $(IMX_PATH)/arm-trusted-firmware/ PLAT=$${ATF_PLATFORM} clean; \
	$(MAKE) -C $(IMX_PATH)/arm-trusted-firmware/ CROSS_COMPILE="$(ATF_CROSS_COMPILE)" PLAT=$${ATF_PLATFORM} bl31 -B; \
	cp --remove-destination $(IMX_PATH)/arm-trusted-firmware/build/$${ATF_PLATFORM}/release/bl31.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$${MKIMAGE_PLATFORM}/bl31.bin; \
	cp --remove-destination $(FSL_PROPRIETARY_PATH)/linux-firmware-imx/firmware/seco/mx8qx-ahab-container.img $(IMX_MKIMAGE_PATH)/imx-mkimage/$${MKIMAGE_PLATFORM}/mx8qx-ahab-container.img; \
	cp --remove-destination $(DIGI_PROPRIETARY_PATH)/uboot-firmware/imx8q/$${UBOOT_PLATFORM}_scfw-tcm.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$${MKIMAGE_PLATFORM}/scfw_tcm.bin; \
	cp --remove-destination $(TARGET_BOOTLOADER_PREBUILT_CM4) $(IMX_MKIMAGE_PATH)/imx-mkimage/$${MKIMAGE_PLATFORM}/CM4.bin; \
	cp --remove-destination $(UBOOT_OUT)/u-boot.$(strip $(1)) $(IMX_MKIMAGE_PATH)/imx-mkimage/$${MKIMAGE_PLATFORM}/u-boot.bin; \
	cp --remove-destination $(UBOOT_OUT)/tools/mkimage  $(IMX_MKIMAGE_PATH)/imx-mkimage/$${MKIMAGE_PLATFORM}/mkimage_uboot; \
	for target in $(TARGET_BOOTLOADER_IMXMKIMAGE_TARGETS); do \
		$(MAKE) -C $(IMX_MKIMAGE_PATH)/imx-mkimage/ clean; \
		$(MAKE) -C $(IMX_MKIMAGE_PATH)/imx-mkimage/ SOC=$${MKIMAGE_PLATFORM} $${target}; \
		install -D $(IMX_MKIMAGE_PATH)/imx-mkimage/$${MKIMAGE_PLATFORM}/flash.bin $(PRODUCT_OUT)/u-boot-$${UBOOT_PLATFORM}-$${target}.imx; \
		cp --remove-destination $(PRODUCT_OUT)/u-boot-$${UBOOT_PLATFORM}-$${target}.imx $(PRODUCT_OUT)/u-boot-$${UBOOT_PLATFORM}.imx; \
	done;
endef


