# dev 0 = Internal EMMC
# dev 1 = SD card
mmc dev 1
fatload mmc 1:1 ${kernel_addr_r} Image
fatload mmc 1:1 ${fdt_addr_r} rockchip/rk3399-rock-pi-4c.dtb
setenv bootargs init=/sbin/init console=tty1 console=ttyS2,1500000 no_console_suspend earlycon=uart,mmio32,0xff1a0000 swiotlb=1 coherent_pool=1m earlyprintk rw rootwait root=/dev/mmcblk1p2
booti ${kernel_addr_r} - ${fdt_addr_r}
