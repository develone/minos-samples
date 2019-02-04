ARCH 		:= aarch64
CROSS_COMPILE 	:= aarch64-linux-gnu-
CC 		:= $(CROSS_COMPILE)gcc
LD 		:= $(CROSS_COMPILE)ld
OBJ_COPY	:= $(CROSS_COMPILE)objcopy
OBJ_DUMP 	:= $(CROSS_COMPILE)objdump
NM		:= $(CROSS_COMPILE)nm
STRIP		:= $(CROSS_COMPILE)strip

PWD		:= $(shell pwd)

QUIET ?= @

all : aarch32-boot.image aarch64-boot.image
	@echo "Build Boot Image For Guest VM Done"

aarch32-boot.image: gvm-aarch32/guest-vm-aarch32.dts gvm-aarch32/Image gvm-aarch32/ramdisk.img
	@dtc -I dts -O dtb -o guest-vm-aarch32.dtb gvm-aarch32/guest-vm-aarch32.dts
	@abootimg --create aarch32-boot.img -c kerneladdr=0x80008000 -c ramdiskaddr=0x83000000 \
		-c secondaddr=0x83e00000 -c cmdline="console=hvc0 loglevel=8 consolelog=9" \
		-k gvm-aarch32/Image -s guest-vm-aarch32.dtb -r gvm-aarch32/ramdisk.img

aarch64-boot.image: gvm-aarch64/guest-vm-aarch64.dts gvm-aarch64/Image gvm-aarch64/ramdisk.img
	@dtc -I dts -O dtb -o guest-vm-aarch64.dtb gvm-aarch64/guest-vm-aarch64.dts
	@abootimg --create aarch64-boot.img -c kerneladdr=0x80080000 -c ramdiskaddr=0x83000000 \
		-c secondaddr=0x83e00000 -c cmdline="console=hvc0 loglevel=8 consolelog=9" \
		-k gvm-aarch64/Image -s guest-vm-aarch64.dtb -r gvm-aarch64/ramdisk.img

.PHONY := clean

clean :
	@rm -rf guest-vm-aarch32.dtb guest-vm-aarch64.dtb aarch64-boot.img aarch32-boot.img

