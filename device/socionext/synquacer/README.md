To install OpenMandriva Lx on Synquacer:

* Insert a USB stick on another machine
* Create a GPT partition table with 2 partitions on it:
  * Partition 1: UEFI System Partition (tag ef00), formatted as FAT32
  * Partition 2: Linux aarch64 root partition (tag 8305), formatted as ext4
* Uncompress boot-synquacer.tar.xz on partition 1
* Uncompress rootfs-synquacer.tar.xz on partition 2
* Put the USB stick into your synquacer and boot it from the USB stick
* Log in as user "omv" with password "omv"
* If you want to install OpenMandriva Lx to the harddisk or internal storage,
  run ./install-openmandriva from /home/omv
