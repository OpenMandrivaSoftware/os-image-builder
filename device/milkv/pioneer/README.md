# Milk-V Pioneer (Sophgo SG2042)

Builds a bootable disk image for the Milk-V Pioneer RISC-V workstation.

This target is for the firmware that actually shipped on most boards:
ZSBL → OpenSBI → Sophgo U-Boot (or LinuxBoot). That firmware is **not**
UEFI; it loads `/extlinux/extlinux.conf` from a FAT partition. EDK2
exists as an optional later firmware and is not assumed here.

The image has:

* a 256 MiB FAT boot partition (`/boot`, label `OMVBOOT`) with
  `extlinux/extlinux.conf`, `Image`, `initrd.img` and the board DTB
* a Linux RISC-V root partition (`LABEL=OMVROOT`)

Write the `.img` to a USB stick or NVMe. The U-Boot already in SPI flash
should find the FAT partition and boot it. The micro-USB debug port is
`ttyS0` at 115200.

Do **not** write this image to the onboard microSD if you rely on that
card as the firmware source: ZSBL looks for `fip.bin` / `zsbl.bin` on
the first FAT partition of an inserted SD card. This image is the OS
payload only; it does not replace the board firmware.

```
./build -P core milkv/pioneer
```

* Log in as user `omv` with password `omv`
* To install to internal NVMe, run `./install-openmandriva` from `/home/omv`

## Kernel

Mainline has a Pioneer DTB (`sophgo/sg2042-milkv-pioneer`) but the
upstream SG2042 PCIe host is still not usable on this board (hangs or
mis-enumerates; NVMe and the GPU sit behind it). The image therefore
builds Sophgo's vendor kernel:

`https://github.com/sophgo/linux-riscv` branch `sg2042-dev-6.6`
(`sophgo_mango_ubuntu_defconfig`, DTB `sophgo/mango-milkv-pioneer`).

The old `sg2042-dev` branch name no longer exists on that repo.
`sg2042-revyos-6.12` is the other current vendor tree (different
defconfig) if you want to experiment with 6.12.

`neovim` does not cross-compile, so this target (like any new
architecture) gets `vim` from `packagesets/rootfs.pkgs`.

`dracut-modules-growroot` is a separate noarch package
(`cloud-initramfs-tools`), not part of `dracut`. Until it is
published into cooker/riscv64, `write2device` grows the root
filesystem after `dd`. `./install-openmandriva` needs `mkfs.vfat`
from `dosfstools` once that package exists for riscv64.
