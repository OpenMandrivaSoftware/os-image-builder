gpio set 114

if test ${mmc_bootdev} -eq 0 ; then
	echo "Booting from SD"
	setenv bootdev 0
else
	echo "Booting from eMMC"
	setenv bootdev 2
fi

setenv bootargs init=/sbin/init console=tty1 console=ttyS0,115200 cma=256M rw rootwait root=/dev/mmcblk${bootdev}p2

printenv

echo Loading Kernel
load mmc ${mmc_bootdev}:1 ${kernel_addr_r} vmlinuz

echo Loading DTB
load mmc ${mmc_bootdev}:1 ${fdt_addr_r} allwinner/sun50i-a64-pinephone-1.2.dtb

echo Resizing FDT
fdt addr ${fdt_addr_r}
fdt resize

#echo Loading Initramfs
#load mmc ${mmc_bootdev}:1 ${ramdisk_addr_r} initrd.img

gpio set 115

echo "Booting kernel with args ${bootargs}"
gpio set 116
#booti ${kernel_addr_r} ${ramdisk_addr_r}:${filesize} ${fdt_addr_r}
booti ${kernel_addr_r} - ${fdt_addr_r}
