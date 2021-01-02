Installing OpenMandriva Lx on Synquacer
---------------------------------------
To install OpenMandriva Lx on Synquacer:

* Insert a USB storage device on another machine
* Create a GPT partition table with 2 partitions on it:
  * Partition 1: UEFI System Partition (tag ef00), formatted as FAT32
  * Partition 2: Linux aarch64 root partition (tag 8305), formatted as ext4
* Uncompress boot-synquacer.tar.xz on partition 1 (Ignore any possible warnings about file flags, they're caused by limitations of the FAT filesystem and harmless)
* Uncompress rootfs-synquacer.tar.xz on partition 2
* Put the USB storage device into your synquacer and boot it from the USB device
* Log in as user "omv" with password "omv"
* If you want to install OpenMandriva Lx to the harddisk or internal storage,
  run ./install-openmandriva from /home/omv

Example: Create the bootable/installable USB storage device
-----------------------------------------------------------
This is assuming you've downloaded the OpenMandriva Lx install tarballs to
`~/Downloads`, and `/dev/sdb` is your USB storage device.
```
$ sudo gdisk /dev/sdb
GPT fdisk (gdisk) version 1.0.4

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.

Command (? for help): o
This option deletes all partitions and creates a new protective MBR.
Proceed? (Y/N): y

Command (? for help): n
Partition number (1-128, default 1): 
First sector (34-15257566, default = 2048) or {+-}size{KMGTP}: 
Last sector (2048-15257566, default = 15257566) or {+-}size{KMGTP}: +512M
Current type is 'Linux filesystem'
Hex code or GUID (L to show codes, Enter = 8300): ef00
Changed type of partition to 'EFI System'

Command (? for help): n
Partition number (2-128, default 2): 
First sector (34-15257566, default = 1050624) or {+-}size{KMGTP}: 
Last sector (1050624-15257566, default = 15257566) or {+-}size{KMGTP}: 
Current type is 'Linux filesystem'
Hex code or GUID (L to show codes, Enter = 8300): 8305
Changed type of partition to 'Linux ARM64 root (/)'

Command (? for help): w

Final checks complete. About to write GPT data. THIS WILL OVERWRITE EXISTING
PARTITIONS!!

Do you want to proceed? (Y/N): y
OK; writing new GUID partition table (GPT) to /dev/sdb.
The operation has completed successfully.
$ sudo mkfs.vfat /dev/sdb1
mkfs.fat 4.1 (2017-01-24)
$ sudo mkfs.ext4 /dev/sdb2
mke2fs 1.44.5 (15-Dec-2018)
Creating filesystem with 1775867 4k blocks and 444400 inodes
Filesystem UUID: 01b72f4e-f359-4715-a65e-2800771cbf12
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done 

$ sudo mount /dev/sdb1 /mnt
$ cd /mnt
$ sudo tar xf ~/Downloads/boot-synquacer.tar.xz
EFI/: Failed to set file flags
EFI/openmandriva/: Failed to set file flags
EFI/openmandriva/linux.efi: Failed to set file flags
EFI/openmandriva/initrd.img: Failed to set file flags
startup.nsh: Failed to set file flags
tar: Error exit delayed from previous errors.
$ cd
$ sudo umount /mnt
$ sudo mount /dev/sdb2 /mnt
$ cd /mnt
$ sudo tar xf ~/Downloads/rootfs-synquacer.tar.xz
$ cd
$ sudo umount /mnt
$ sudo eject /dev/sdb
$ sudo sync
```
