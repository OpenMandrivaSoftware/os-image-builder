# OpenMandriva Live DVD (x86_64)

This target builds a traditional desktop Live image: a hybrid
**iso9660 + UDF** ISO that boots on BIOS and UEFI machines (optical media
or USB) and uses **overlayfs** so the read-only disc is writable at runtime.

```
./build -P kde x86-64-live
```

The resulting `*.iso` is in `results/x86-64-live/`.

* Boot the ISO
* Log in as user `omv` with password `omv`
* To install to a hard disk, run `./install-openmandriva` from `/home/omv`
