module "networking" {
  source = "./modules/networking"
}

module "storage" {
  source = "./modules/storage"
  
  number_worker_nodes         = var.number_worker_nodes
  worker_node_volume_size_gb  = var.worker_node_volume_size_gb
}
