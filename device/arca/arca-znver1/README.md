# arca images
Arca images are essentially custom builds of OpenMandriva Server for
Arca on znver1 hosts.

They differ from the regular server images by putting a btrfs /srv at the
end of the disk (growing to maximum size) so /srv - expected to contain most
data at Arca - can be expanded without having to risk any changes in /
or other parts relevant to the OS.
