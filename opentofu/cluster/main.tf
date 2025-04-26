module "networking" {
  source = "./modules/networking"
}

module "storage" {
  source = "./modules/storage"
  
  number_worker_nodes         = var.number_worker_nodes
  worker_node_volume_size_gb  = var.worker_node_volume_size_gb
}

module "compute" {
  source = "./modules/compute"

  ssh_public_key              = var.ssh_public_key
  network_name                = var.network_name
  os_image_name               = var.os_image_name
  number_control_nodes        = var.number_control_nodes
  control_plane_flavor        = var.control_plane_flavor
  number_worker_nodes         = var.number_worker_nodes
  worker_node_flavor          = var.worker_node_flavor
  rook_volume_ids             = module.storage.rook_volume_ids
  worker_node_volume_device   = var.worker_node_volume_device
}
