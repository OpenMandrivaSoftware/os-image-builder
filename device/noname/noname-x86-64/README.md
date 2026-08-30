# Noname images
Noname images are essentially custom builds of OpenMandriva Desktop for
you-know-what project.

They differ from the regular server images by putting a btrfs `/home` at the
end of the disk (growing to maximum size) so `/home` — expected to contain most
data — can be expanded without having to risk any changes in `/` or other parts
relevant to the OS. `/` defaults to 10G; pass `-m SIZE` (e.g. `-m 20G`) if `/`
itself needs more room to grow. `-H SIZE` raises `/home` (already last) to
at least that size.

That home filesystem uses the `@home` subvolume (mounted with `subvol=@home`).
Additional storage can later be attached with `btrfs device add` on the home
filesystem. See the main project README and `helpers/partitions` for the
`PARTITIONS` / subvolume format.
