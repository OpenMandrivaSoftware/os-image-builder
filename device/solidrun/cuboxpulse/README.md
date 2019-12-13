= Installing on CuBox Pulse =

* Partition an SD card with partition 1 starting at sector 8192
* Untar the root filesystem to partition 1
* Copy the boot image flash.bin to the boot area: dd if=flash.bin of=/dev/sdx bs=1024 seek=33
* Boot from the SD card
* Useful commands at the u-boot prompt:
  mmc dev mmc1 1
  part list mmc 1
  ext4ls mmc 1 /boot
  test -e mmc 1:1 /sbin/init
  setenv devnum 1
  run scan_dev_for_boot
  load mmc 1:1 ${loadaddr} /boot/Image
  load mmc 1:1 ${fdt_addr_r} /boot/freescale/${fdt_file}
  load mmc 1:1 ${ramdisk_addr_r} /boot/initrd.img
  booti ${loadaddr} - ${fdt_addr_r}
  booti ${loadaddr} ${ramdisk_addr_r}:${filesize} ${fdt_addr_r}
