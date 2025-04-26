variable "number_worker_nodes" {
    description = "Number of worker nodes"
    type        = number
    default     = 3
}

variable "worker_node_volume_size_gb" {
    description = "Size in gigabytes for the volume to create on each worker node"
    type        = number
    default     = 150
}
