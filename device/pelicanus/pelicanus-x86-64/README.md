# Pelicanus images
Pelicanus images are essentially custom builds of OpenMandriva Server for
Pelicanus.

They differ from the regular server images by putting a btrfs `/srv` at the
end of the disk (growing to maximum size) so `/srv` — expected to contain most
data at Pelicanus — can be expanded without having to risk any changes in `/`
or other parts relevant to the OS. `/` defaults to 10G; pass `-m SIZE` (e.g.
`-m 20G`) if `/` itself needs more room to grow. `-H SIZE` adds a dedicated
`/home` of at least that size; `/srv` stays the last (growable) partition.

That data filesystem uses the `@srv` subvolume (mounted with `subvol=@srv`).
Docker’s data root is linked under `/srv`. Additional storage can later be
attached with `btrfs device add` on the `/srv` filesystem. See the main project
README and `helpers/partitions` for the `PARTITIONS` / subvolume format.
