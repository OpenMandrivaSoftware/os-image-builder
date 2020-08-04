gpio set 114

if test ${mmc_bootdev} -eq 0 ; then
	echo "Booting from SD";
	setenv bootdev 0;
else
	echo "Booting from eMMC";
	setenv bootdev 2;
fi;

setenv bootargs init=/sbin/init rw console=tty0 console=ttyS0,115200 no_console_suspend earlycon=uart,mmio32,0x01c28000 panic=10 consoleblank=0 loglevel=1 cma=256M root=/dev/mmcblk${bootdev}p2

printenv

echo Loading DTB
load mmc ${mmc_bootdev}:1 ${fdt_addr_r} allwinner/sun50i-a64-pinephone-1.2.dtb

echo Loading Initramfs
load mmc ${mmc_bootdev}:1 ${ramdisk_addr_r} uInitrd.img

echo Loading Kernel
load mmc ${mmc_bootdev}:1 ${kernel_addr_r} vmlinuz

gpio set 115

echo Resizing FDT
fdt addr ${fdt_addr_r}
fdt resize

echo Booting kernel
gpio set 116
booti ${kernel_addr_r} ${ramdisk_addr_r} ${fdt_addr_r}
