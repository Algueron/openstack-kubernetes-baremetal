data "openstack_images_image_v2" "os_image" {
  name        = var.os_image_name
  most_recent = true
}

data "openstack_compute_flavor_v2" "control_plane_flavor" {
  name = var.control_plane_flavor
}

data "openstack_compute_flavor_v2" "worker_node_flavor" {
  name = var.worker_node_flavor
}

resource "openstack_compute_keypair_v2" "kubernetes_keypair" {
  name       = "kubernetes-keypair"
  public_key = var.ssh_public_key
}

resource "openstack_compute_instance_v2" "control_plane_node" {
  count           = var.number_control_nodes

  name            = "mycluster-k8s-node-master-${count.index}"
  image_id        = data.openstack_images_image_v2.os_image.id
  flavor_id       = data.openstack_compute_flavor_v2.control_plane_flavor.id
  key_pair        = "kubernetes-keypair"
  security_groups = ["default", "kubernetes-master", "allow-ssh", "allow-icmp"]

  network {
    name          = var.network_name
  }
}

resource "openstack_compute_instance_v2" "worker_node" {
  count           = var.number_worker_nodes

  name            = "mycluster-k8s-node-worker-${count.index}"
  image_id        = data.openstack_images_image_v2.os_image.id
  flavor_id       = data.openstack_compute_flavor_v2.worker_node_flavor.id
  key_pair        = "kubernetes-keypair"
  security_groups = ["default", "kubernetes-node", "allow-ssh", "allow-icmp"]

  network {
    name          = var.network_name
  }
}

resource "openstack_compute_volume_attach_v2" "rook_attach" {
  count           = var.number_worker_nodes

  instance_id     = openstack_compute_instance_v2.worker_node[count.index].id
  volume_id       = var.rook_volume_ids[count.index]
  device          = var.worker_node_volume_device
}
