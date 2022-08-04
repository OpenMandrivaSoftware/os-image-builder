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

`./build -P kde -P audio -p vim-enhanced pi4b`

Unless _-W_ is given, weak dependencies (Suggests:/Recommends:) are installed
automatically.

Additional repositories
=======================
If you wish to include packages from repositories other than _main_ (such as
_unsupported_, _restricted_ or _non-free_), use -r to enable those repositories.
For example, to build an image that has x264 included, use

`./build -P kde -r restricted -p x264 rockpi4c`

Selecting a desktop
===================
If you want to use a custom desktop, add _-d desktop_ to the command line, where
_desktop_ is the name of a desktop file found in `/usr/share/xsessions` or
`/usr/share/wayland-sessions`.

By default, os-image-builder checks what desktops are installed, and uses, in that
order, _kde_, _lxqt_, _openbox_, _failsafe_, _plasmamobile_, _kdewayland_,
_weston_.

For example, to build a Raspberry Pi 4B image that launches lxqt
even if KDE is installed as well, use

`./build -d lxqt pi4b`

Note that _-d desktop_ only changes the default setting. It doesn't replace adding
the package set(s) needed to use the desktop.

Selecting services
==================
If you wish to start extra systemd services (or disable standard services), you can
pass _-s service_ to enable a service or _-S service_ to disable a service that would
otherwise be enabled by default.

For example, when building an image for running inside openstack, it may make sense
to use

`./build -p cloud-init -s cloud-init aarch64-uefi-iso`

Using the right version
=======================
By default, _os-image-builder_ builds from _cooker_, the development repositories.
If you wish to use the _rolling_ repository or a released version, add `-v _version_`

Output
======
Generated images are put into the `results` directory.

Adding new packagesets
======================
Simply create a new file in the packagesets directory. The format is just a list of
package names; in addition, it is run through the C preprocessor, so you can use e.g.
`#include "xyz.pkgs"` to include another package set.
LIB(xyz) expands to the package name for the xyz library (libxyz or lib64xyz,
depending on the CPU architecture).
There are also defines for the target architecture and the included packagesets.
For example,

`./build -p kde synquacer`

Would result in `ARCH_aarch64`, `TARGET_synquacer` and `PACKAGESET_kde` being defined,
allowing for a packageset to say e.g.

```
libreoffice
#ifdef PACKAGESET_kde
libreoffice-kde
#endif
```

to add libreoffice and if (and only if) the kde packageset is included, its kde
integration extensions.

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

`KERNELRPM=_package name_` Package name of the kernel to be installed (typically
kernel-desktop or kernel-server). This can also be multiple packages separated
by spaces, e.g. `KERNELRPM="kernel-server kernel-server-modules-infiniband"`
Alternatively, if your target device uses a custom kernel, set the parameters below:

`KERNEL=_url of kernel git repository_` URL of the git repository for the kernel
to be used. Optionally, a branch can be specified by appending _#branch_. For
example, to pull in the Raspberry Pi 5.10 kernel, use
`KERNEL=https://github.com/raspberrypi/linux.git#rpi-5.10.y`
If no kernel is specified, the binary package specified by `KERNELRPM`
(default: kernel-desktop) will be pulled from OpenMandriva repositories instead.

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

`KERNEL_GCC=_yes_|_no_` Define whether or not to build the kernel with the
gcc toolchain (default: use clang)

`CREATE_DEFAULT_USER=_yes_|_no_` Define whether or not the default user (username
omv with password omv) is created. Since you need a user, this is enabled by default
(but it can make sense to turn it off if the user is created by other means, such
as cloud-init)

In addition to the `config` file, you can override the default behavior by creating
scriptlets called `generate-initrd`, `generate-rootfs`, `generate-bootimg`,
`setup-system-files`, `download_kernel_extras` and `postprocess`.
Please refer to existing target devices to see what goes into those scripts.

You can also add a `write2sd.in` or `write2device.in` script that will be sent to
the output directory, containing the instructions needed to write the generated image
to an SD card or device (typically `dd`-ing the image to the target device, potentially
plus enlarging the root filesystem to fill the disk etc.)

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
