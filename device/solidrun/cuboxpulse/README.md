= Installing on CuBox Pulse =

* Partition an SD card with partition 1 starting at sector 8192
* Untar the root filesystem to partition 1
* Copy the boot image flash.bin to the boot area: dd if=flash.bin of=/dev/sdx bs=1024 seek=33
