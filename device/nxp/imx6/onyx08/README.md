# Booting OpenMandriva from SD card on onyx08
## Partition layout
```
$ sudo fdisk -l /dev/sdc
[sudo] password for bero: 
Disk /dev/sdc: 14.9 GiB, 15931539456 bytes, 31116288 sectors
Disk model: Mass-Storage    
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x000c9b02

Device     Boot   Start      End  Sectors  Size Id Type
/dev/sdc1         16384    81919    65536   32M  c W95 FAT32 (LBA)
/dev/sdc2         81920   147455    65536   32M  c W95 FAT32 (LBA)
/dev/sdc3        147456  8519679  8372224    4G  f W95 Ext'd (LBA)
/dev/sdc4       8519680 31115263 22595584 10.8G 83 Linux
/dev/sdc5        149504  6289407  6139904    3G 83 Linux

Partition table entries are not in disk order.
```
Partitions 1 and 2 (despite their type) don't actually contain a FAT
filesystem.
They contain the kernel, DeviceTree files and initrd, combined into an
Android style boot.img.
Partition 1 is the regular boot partition, partition 2 is for recovery
mode.
While this hasn't been verified, probably the start points of the
partitions (rather than partition numbers) are hardcoded in the
bootloader.
Partition 4 is the root filesystem
Partition 5 is the home filesystem

To install the images generated by os-image-builder (assuming /dev/sdc is
your SD card):
```
sudo dd if=boot.img of=/dev/sdc1
sudo dd if=boot.img of=/dev/sdc2
sudo mkfs.ext4 /dev/sdc4
sudo mkfs.ext4 /dev/sdc5
sudo mount /dev/sdc4 /mnt
cd /mnt
sudo tar xf /path/to/rootfs-onyx08.tar.xz
cd
sudo umount /mnt
sudo sync
sudo eject /dev/sdc
```
