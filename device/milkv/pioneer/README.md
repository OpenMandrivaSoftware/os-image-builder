# Milk-V Pioneer (Sophgo SG2042)

Builds a bootable disk image for the Milk-V Pioneer RISC-V workstation.

The Pioneer firmware is EDK2/UEFI. The image has:

* a 256 MiB EFI System Partition (`/boot/efi`) containing GRUB
  (`EFI/BOOT/BOOTRISCV64.EFI`)
* a Linux RISC-V root partition (`LABEL=OMVROOT`)

Write the `.img` to a USB stick or NVMe and select the USB/NVMe entry in
the Pioneer firmware boot menu. The micro-USB debug port is `ttyS0` at 115200.

```
./build pioneer
```

* Log in as user `omv` with password `omv`
* To install to internal storage, run `./install-openmandriva` from `/home/omv`
