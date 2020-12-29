Welcome to OpenMandriva os-image-builder
========================================

_os-image-builder_ is OpenMandriva's approach to targeting devices beyond
PCs and generic UEFI capable ARM boards.
It is a bit of a hybrid between a traditional desktop OS ISO builder (like
our own [_omdv-build-iso_](https://github.com/OpenMandrivaSoftware/omdv-build-iso), currently still used to build x86 install images)
and an embedded distribution builder like [OpenEmbedded](http://openembedded.org/) or Yocto.

Especially in the ARM world, the traditional approach of "one ISO file for
every device" doesn't work -- many boards require custom patches, outside
of server boards, few have standardized on a common boot process. Many
distributions "solve" this by only targeting UEFI capable boards - but we
don't want that limitiation.

_os-image-builder_ can build a custom kernel and bootloader for every target
board (the custom kernel ends up being packaged as an rpm, so it can still
be updated through _dnf_), and each board can have a custom way of building
the final images - from UEFI compliant booting to having to create an Android
style "sparse image" and flashing it with _fastboot_.
Board config files control the kernel source location, kernel configuration
options, additional package sets (e.g. needed drivers or firmware packages)
and more.

All other packages are pulled from the normal OpenMandriva repositories.

Where to run os-image-builder
=============================
_os-image-builder_ makes some assumptions about the host system - in particular it
assumes dnf is available, binaries for the target architectures can be run (e.g. by
having a corresponding qemu installed and registered with binfmt-misc, the way
OpenMandriva qemu packages do).

It is therefore recommended to run _os-image-builder_ on OpenMandriva -- but other
similar distributions may work.
If you don't have an OpenMandriva installation, a containerized OpenMandriva, e.g.
`docker run -ti openmandriva/cooker /bin/sh` is sufficient.

Selecting packages
==================
Without parameters saying otherwise, _os-image-builder_ builds a minimal image.
You can add individual packages by adding _-p packagename_, or bigger sets of
packages (e.g. whole desktop environments) with _-P packageset_.

For a list of available packagesets, simply look at the contents of the
_packagesets_ directory.

e.g. to build a minimal image for generic UEFI compliant aarch64 boards, do

`./build aarch64-uefi`

or to build a Raspberry Pi 4B image with KDE and audio support and vim-enhanced, use

`./build -P plasma -P audio -p vim-enhanced pi4b`

Using the right version
=======================
By default, _os-image-builder_ builds from _cooker_, the development repositories.
If you wish to use the _rolling_ repository or a released version, add `-v _version_`

Adding new packagesets
======================
Simply create a new file in the packagesets directory. The format is just a list of
package names; in addition, you can use `#include xyz` to include another package set.
You ${LIB} expands to lib or lib64, depending on the CPU architecture.

Adding new target devices
=========================
You can add support for new target devices by creating a new directory in the
`device/_maker_/_device_` directory structure.

It is recommended to copy the files from a directory describing a similar device
and making modifications as needed, but here's how to add a device from scratch:

The only required file in the new directory is a file called `config`, specifying
some of the following options:

`ARCH=_arch_` specifies which CPU architecture the target device uses. This must
(obviously) correspond to a CPU architecture supported by the OpenMandriva version
you're building. This is the only required option.

`KERNEL=_url of kernel git repository_` URL of the git repository for the kernel
to be used. Optionally, a branch can be specified by appending _#branch_. For
example, to pull in the Raspberry Pi 5.10 kernel, use
`KERNEL=https://github.com/raspberrypi/linux.git#rpi-5.10.y`
If no kernel is specified, the binary package kernel-release will be pulled from
OpenMandriva repositories instead.

`KERNEL_CONFIG=_kernel-config_` Kernel configuration (as in `ls arch/*/configs`
inside the kernel source tree). If not specified, `defconfig` is used.

`KERNEL_EXTRACONFIG=_extra-config_` Extra configuration options to override
_KERNEL_CONFIG_. Use `--enable _option_`, `--disable _option_`,
`--module _option_`, `--set-val _option_ _value_`.

`DTB=_dtb_` DeviceTree file to be used (If not specified, DeviceTree isn't used)

`CMDLINE=_cmdline_` Command line options passed to the kernel

`USE_UEFI=_yes_|_no_` Define whether or not the device uses UEFI

`NEED_INITRD=_yes_|_no_` Define whether or not an initrd/initramfs is needed
to boot

`KERNEL_CLANG=_yes_|_no_` Define whether or not to build the kernel with the
clang toolchain (as opposed to gcc)

In addition to the `config` file, you can override the default behavior by creating
scriptlets called `generate-initrd`, `generate-rootfs`, `generate-bootimg`,
`setup-system-files`, `download_kernel_extras` and `postprocess`.
Please refer to existing target devices to see what goes into those scripts.

You can also create a directory called `kernel-patches` inside the device directory.
Any patch files in this directory will be applied to the kernel after checking them
out. Some patches that are useful to multiple boards can be found in the top level
`kernel-patches` directory. To pull those in, symlink them into your device
`kernel-patches` directory. Add board specific kernel patches directly as files in
the device `kernel-patches` directory.
Patches are applied in shell order - if you need to make sure B is applied
before A, try renaming the files to e.g. 00-B.patch and 01-A.patch.

Please submit any additional boards you're adding to the OpenMandriva project.

---
(c) 2020 [Bernhard "bero" Rosenkränzer](mailto:bero@lindev.ch)
Released under the GPLv3.
