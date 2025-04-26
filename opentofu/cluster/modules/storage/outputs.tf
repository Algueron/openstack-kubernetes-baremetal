output "rook_volume_ids" {
  value = openstack_blockstorage_volume_v3.rook_volume[*].id
}
