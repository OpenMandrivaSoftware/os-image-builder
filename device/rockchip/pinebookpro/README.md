Installing on Pinebook Pro
==========================

Write the generated pinebookpro.img to an SD card with
the _write2sd_ tool (which essentially does the same as _dd_,
but afterwards expands the main partition to fill the SD
card you're using).

Insert the SD card into the Pinebook Pro and boot from it.

The Pinebook Pro's SD card reader seems to take some time to
initialize after a fresh powerup. If it boots to whatever OS
is installed on internal storage even with the OpenMandriva SD
card in the slot on powerup (this seems to happen at times,
especially when using large SD cards), try rebooting - the
bootloader is more likely to do the right thing.
