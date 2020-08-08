# Installing on PinePhone
Write the generated pinephone.img to an SD card with dd
Insert the SD card and boot the phone

# u-boot special commands
gpio 114/115/116 control the LED.
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
