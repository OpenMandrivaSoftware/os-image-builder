Firmware lives in

https://github.com/raspberrypi/firmware

Boot process:

1. Loads and runs the bootcode.bin file from the first partition
   on the SD card, provided the partition has a FAT filesystem.
2. bootcode.bin in turn then loads and runs start.elf (and fixup.dat)
   also from the first partition.
3. start.elf then reads config.txt and sets up any GPU configuration
   requested.
4. start.elf then reads cmdline.txt and loads and runs kernel.img
   (the Linux kernel) or kernel7.img (for Raspberry Pi 2 / Raspberry Pi 3)
   or kernel8.img (64bit), passing it the entire command-line that it
   read from cmdline.txt.

DeviceTree files and overlays generated/installed with
make dtbs_install
*.dtbo (overlay) files live in arch/arm/boot/dts/overlays even for arm64
