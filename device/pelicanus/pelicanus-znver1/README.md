# Pelicanus images
Pelicanus images are essentially custom builds of OpenMandriva Server for
Pelicanus on znver1 hosts.

They differ from the regular server images by putting a btrfs /srv at the
end of the disk (growing to maximum size) so /srv - expected to contain most
data at Pelicanus - can be expanded without having to risk any changes in /
or other parts relevant to the OS.
