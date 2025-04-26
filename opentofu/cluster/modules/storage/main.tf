resource "openstack_blockstorage_volume_v3" "rook_volume" {
  count         = var.number_worker_nodes
  name          = "mycluster-k8s-node-nf-${count.index}-volb"
  description   = "Root Volume for worker node ${count.index}"
  size          = var.worker_node_volume_size_gb
}
