# Installing OpenMandriva Lx on Raspberry Pi 4B
To install OpenMandriva Lx on Raspberry Pi 4B

* Get an SD card (and, if you don't have a built-in SD card reader in your
  other computer, a USB SD card reader)
* Create an MBR partition table with 2 partitions on it:
  * Partition 1: Boot partition (type b), formatted as FAT32
  * Partition 2: Root partition (type 83), formatted as ext4
* Uncompress bootfs-pi4b.tar.xz on partition 1 (Ignore any possible warnings about file flags, they're caused by limitations of the FAT filesystem and harmless)
* Optionally, create extra partitions for swap and /home on the SD card
* Uncompress rootfs-pi4b.tar.xz on partition 2 (if you created a separate /home partition, mount it to ./home first)
* Put the SD card into the Raspberry Pi and start it
* Log in as user "omv" with password "omv"

## Example: Create the bootable/installable USB storage device
This is assuming you've downloaded the OpenMandriva Lx install tarballs to
`~/Downloads`, and `/dev/sdc` is your SD card reader. (USB SD card readers
will generally be /dev/sd*, builtin SD card readers are often /dev/mmcblk*)
```
$ sudo fdisk /dev/sdc

Welcome to fdisk (util-linux 2.33.1).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): o
Created a new DOS disklabel with disk identifier 0x132ec966.

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1): 
First sector (2048-122093567, default 2048): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-122093567, default 122093567): +256M

Created a new partition 1 of type 'Linux' and of size 256 MiB.

Command (m for help): t
Selected partition 1
Hex code (type L to list all codes): b
Changed type of partition 'Linux' to 'W95 FAT32'.

Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (2-4, default 2): 
First sector (526336-122093567, default 526336): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (526336-122093567, default 122093567): 

Created a new partition 2 of type 'Linux' and of size 58 GiB.

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
$ sudo mkfs.vfat /dev/sdc1
mkfs.fat 4.1 (2017-01-24)
$ sudo mkfs.ext4 /dev/sdc2
mke2fs 1.44.5 (15-Dec-2018)
Creating filesystem with 15195904 4k blocks and 3801088 inodes
Filesystem UUID: 5b622681-da9b-4843-a22b-b1573d4a1a9e
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
        4096000, 7962624, 11239424

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (65536 blocks): done
Writing superblocks and filesystem accounting information: done   

$ # If you created a separate /home partition on /dev/sdc3: sudo mkfs.ext4 /dev/sdc3
$ # If you created a separate swap partition on /dev/sdc4: mkswap /dev/sdc4
$ sudo mount /dev/sdc1 /mnt
$ cd /mnt
$ sudo tar xf ~/Downloads/bootfs-pi4b.tar.xz 
./: Failed to set file flags
./fixup_db.dat: Failed to set file flags
./fixup_cd.dat: Failed to set file flags
./bootcode.bin: Failed to set file flags
./config.txt: Failed to set file flags
./start_cd.elf: Failed to set file flags
./start.elf: Failed to set file flags
./start_db.elf: Failed to set file flags
./fixup.dat: Failed to set file flags
./cmdline.txt: Failed to set file flags
./broadcom/: Failed to set file flags
./overlays/: Failed to set file flags
./fixup_x.dat: Failed to set file flags
./start_x.elf: Failed to set file flags
./overlays/ads1015.dtbo: Failed to set file flags
./overlays/hifiberry-dac.dtbo: Failed to set file flags
./overlays/rpi-display.dtbo: Failed to set file flags
./overlays/dwc-otg.dtbo: Failed to set file flags
./overlays/piscreen2r.dtbo: Failed to set file flags
./overlays/dpi24.dtbo: Failed to set file flags
./overlays/audioinjector-addons.dtbo: Failed to set file flags
./overlays/exc3000.dtbo: Failed to set file flags
./overlays/w1-gpio.dtbo: Failed to set file flags
./overlays/vc4-kms-kippah-7inch.dtbo: Failed to set file flags
./overlays/pwm.dtbo: Failed to set file flags
./overlays/enc28j60-spi2.dtbo: Failed to set file flags
./overlays/sc16is750-i2c.dtbo: Failed to set file flags
./overlays/pwm-ir-tx.dtbo: Failed to set file flags
./overlays/pps-gpio.dtbo: Failed to set file flags
./overlays/sx150x.dtbo: Failed to set file flags
./overlays/dionaudio-loco-v2.dtbo: Failed to set file flags
./overlays/vc4-fkms-v3d.dtbo: Failed to set file flags
./overlays/sdio.dtbo: Failed to set file flags
./overlays/mcp3202.dtbo: Failed to set file flags
./overlays/allo-boss-dac-pcm512x-audio.dtbo: Failed to set file flags
./overlays/rpi-sense.dtbo: Failed to set file flags
./overlays/gpio-key.dtbo: Failed to set file flags
./overlays/i2c1-bcm2708.dtbo: Failed to set file flags
./overlays/audioinjector-ultra.dtbo: Failed to set file flags
./overlays/rpi-cirrus-wm5102.dtbo: Failed to set file flags
./overlays/spi-rtc.dtbo: Failed to set file flags
./overlays/hifiberry-digi.dtbo: Failed to set file flags
./overlays/gpio-ir-tx.dtbo: Failed to set file flags
./overlays/pitft35-resistive.dtbo: Failed to set file flags
./overlays/i2c0-bcm2708.dtbo: Failed to set file flags
./overlays/ads1115.dtbo: Failed to set file flags
./overlays/enc28j60.dtbo: Failed to set file flags
./overlays/audioinjector-wm8731-audio.dtbo: Failed to set file flags
./overlays/allo-piano-dac-pcm512x-audio.dtbo: Failed to set file flags
./overlays/i2c-bcm2708.dtbo: Failed to set file flags
./overlays/allo-piano-dac-plus-pcm512x-audio.dtbo: Failed to set file flags
./overlays/i2c-rtc-gpio.dtbo: Failed to set file flags
./overlays/spi2-2cs.dtbo: Failed to set file flags
./overlays/gpio-no-bank0-irq.dtbo: Failed to set file flags
./overlays/mcp23017.dtbo: Failed to set file flags
./overlays/i2s-gpio28-31.dtbo: Failed to set file flags
./overlays/googlevoicehat-soundcard.dtbo: Failed to set file flags
./overlays/rpi-dac.dtbo: Failed to set file flags
./overlays/rotary-encoder.dtbo: Failed to set file flags
./overlays/iqaudio-dacplus.dtbo: Failed to set file flags
./overlays/rpi-tv.dtbo: Failed to set file flags
./overlays/dionaudio-loco.dtbo: Failed to set file flags
./overlays/media-center.dtbo: Failed to set file flags
./overlays/fe-pi-audio.dtbo: Failed to set file flags
./overlays/iqaudio-digi-wm8804-audio.dtbo: Failed to set file flags
./overlays/rpi-proto.dtbo: Failed to set file flags
./overlays/sdhost.dtbo: Failed to set file flags
./overlays/upstream-aux-interrupt.dtbo: Failed to set file flags
./overlays/justboom-digi.dtbo: Failed to set file flags
./overlays/allo-digione.dtbo: Failed to set file flags
./overlays/mpu6050.dtbo: Failed to set file flags
./overlays/pitft28-resistive.dtbo: Failed to set file flags
./overlays/jedec-spi-nor.dtbo: Failed to set file flags
./overlays/ltc294x.dtbo: Failed to set file flags
./overlays/spi0-cs.dtbo: Failed to set file flags
./overlays/gpio-no-irq.dtbo: Failed to set file flags
./overlays/adau7002-simple.dtbo: Failed to set file flags
./overlays/gpio-poweroff.dtbo: Failed to set file flags
./overlays/pi3-disable-bt.dtbo: Failed to set file flags
./overlays/spi2-3cs.dtbo: Failed to set file flags
./overlays/smi.dtbo: Failed to set file flags
./overlays/pi3-miniuart-bt.dtbo: Failed to set file flags
./overlays/upstream.dtbo: Failed to set file flags
./overlays/sc16is752-spi1.dtbo: Failed to set file flags
./overlays/justboom-dac.dtbo: Failed to set file flags
./overlays/tinylcd35.dtbo: Failed to set file flags
./overlays/w1-gpio-pullup.dtbo: Failed to set file flags
./overlays/pi3-disable-wifi.dtbo: Failed to set file flags
./overlays/gpio-ir.dtbo: Failed to set file flags
./overlays/hifiberry-amp.dtbo: Failed to set file flags
./overlays/i2c-sensor.dtbo: Failed to set file flags
./overlays/midi-uart1.dtbo: Failed to set file flags
./overlays/lirc-rpi.dtbo: Failed to set file flags
./overlays/sc16is752-i2c.dtbo: Failed to set file flags
./overlays/mmc.dtbo: Failed to set file flags
./overlays/audremap.dtbo: Failed to set file flags
./overlays/bmp085_i2c-sensor.dtbo: Failed to set file flags
./overlays/hy28b-2017.dtbo: Failed to set file flags
./overlays/gpio-shutdown.dtbo: Failed to set file flags
./overlays/mcp3008.dtbo: Failed to set file flags
./overlays/smi-nand.dtbo: Failed to set file flags
./overlays/smi-dev.dtbo: Failed to set file flags
./overlays/gpio-fan.dtbo: Failed to set file flags
./overlays/vc4-kms-v3d.dtbo: Failed to set file flags
./overlays/vga666.dtbo: Failed to set file flags
./overlays/akkordion-iqdacplus.dtbo: Failed to set file flags
./overlays/spi0-hw-cs.dtbo: Failed to set file flags
./overlays/midi-uart0.dtbo: Failed to set file flags
./overlays/iqaudio-dac.dtbo: Failed to set file flags
./overlays/dht11.dtbo: Failed to set file flags
./overlays/mz61581.dtbo: Failed to set file flags
./overlays/pisound.dtbo: Failed to set file flags
./overlays/pi3-act-led.dtbo: Failed to set file flags
./overlays/piscreen.dtbo: Failed to set file flags
./overlays/rpi-backlight.dtbo: Failed to set file flags
./overlays/i2c-rtc.dtbo: Failed to set file flags
./overlays/qca7000.dtbo: Failed to set file flags
./overlays/uart1.dtbo: Failed to set file flags
./overlays/spi1-3cs.dtbo: Failed to set file flags
./overlays/uart0.dtbo: Failed to set file flags
./overlays/balena-fin.dtbo: Failed to set file flags
./overlays/papirus.dtbo: Failed to set file flags
./overlays/hy28b.dtbo: Failed to set file flags
./overlays/ads7846.dtbo: Failed to set file flags
./overlays/adau1977-adc.dtbo: Failed to set file flags
./overlays/i2c-gpio.dtbo: Failed to set file flags
./overlays/hy28a.dtbo: Failed to set file flags
./overlays/applepi-dac.dtbo: Failed to set file flags
./overlays/pibell.dtbo: Failed to set file flags
./overlays/allo-katana-dac-audio.dtbo: Failed to set file flags
./overlays/i2c-mux.dtbo: Failed to set file flags
./overlays/dwc2.dtbo: Failed to set file flags
./overlays/dpi18.dtbo: Failed to set file flags
./overlays/i2c-pwm-pca9685a.dtbo: Failed to set file flags
./overlays/hifiberry-digi-pro.dtbo: Failed to set file flags
./overlays/spi2-1cs.dtbo: Failed to set file flags
./overlays/at86rf233.dtbo: Failed to set file flags
./overlays/goodix.dtbo: Failed to set file flags
./overlays/pitft28-capacitive.dtbo: Failed to set file flags
./overlays/mbed-dac.dtbo: Failed to set file flags
./overlays/mcp2515-can1.dtbo: Failed to set file flags
./overlays/spi1-1cs.dtbo: Failed to set file flags
./overlays/wittypi.dtbo: Failed to set file flags
./overlays/hd44780-lcd.dtbo: Failed to set file flags
./overlays/pitft22.dtbo: Failed to set file flags
./overlays/rpi-ft5406.dtbo: Failed to set file flags
./overlays/mcp2515-can0.dtbo: Failed to set file flags
./overlays/pwm-2chan.dtbo: Failed to set file flags
./overlays/sdio-1bit.dtbo: Failed to set file flags
./overlays/hifiberry-dacplus.dtbo: Failed to set file flags
./overlays/mcp23s17.dtbo: Failed to set file flags
./overlays/rpi-poe.dtbo: Failed to set file flags
./overlays/spi-gpio35-39.dtbo: Failed to set file flags
./overlays/superaudioboard.dtbo: Failed to set file flags
./overlays/sdtweak.dtbo: Failed to set file flags
./overlays/rra-digidac1-wm8741-audio.dtbo: Failed to set file flags
./overlays/spi1-2cs.dtbo: Failed to set file flags
./broadcom/bcm2710-rpi-3-b.dtb: Failed to set file flags
./broadcom/bcm2710-rpi-cm3.dtb: Failed to set file flags
./broadcom/bcm2837-rpi-cm3-io3.dtb: Failed to set file flags
./broadcom/bcm2837-rpi-3-b.dtb: Failed to set file flags
./broadcom/bcm2710-rpi-3-b-plus.dtb: Failed to set file flags
./broadcom/bcm2837-rpi-3-b-plus.dtb: Failed to set file flags
tar: Error exit delayed from previous errors.
$ cd
$ sudo umount /mnt
$ sudo mount /dev/sdc2 /mnt
$ cd /mnt
$ # If you created a separate /home partition on /dev/sdc3: sudo mkdir home; sudo mount /dev/sdc3 home
$ sudo tar xf ~/Downloads/rootfs-pi4b.tar.xz
$ # If you created separate /home and/or swap partitions: vi etc/fstab and adjust the file
$ # If you created a separate /home partition: sudo umount home
$ cd
$ sudo umount /mnt
$ sudo eject /dev/sdc
$ sudo sync
```
