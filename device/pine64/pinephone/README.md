Installing on PinePhone
=======================
Write the generated pinephone.img to an SD card using the
write2sd tool (it uses dd to 
Insert the SD card and boot the phone

u-boot special commands
=======================
If you want to give progress indications during early boot, you can
modify the u-boot configuration to tweak LEDs.

Use the gpio command in u-boot to turn ports 114, 115 and 116 on
and off:

| 114 | 115 | 116 | color          |
| --- | --- | --- | ---            |
| 0   | 0   | 0   | off            |
| 0   | 0   | 1   | blue           |
| 0   | 1   | 0   | red            |
| 0   | 1   | 1   | purple         |
| 1   | 0   | 0   | green          |
| 1   | 0   | 1   | blue-ish green |
| 1   | 1   | 0   | yellow         |
| 1   | 1   | 1   | white          |

Once the Linux kernel is booted, you can control the LEDs through
sysfs.
