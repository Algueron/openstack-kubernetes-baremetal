variable "ssh_public_key" {
    description = "Pulic key to connect to virtual machines"
    type        = string
}

variable "network_name" {
    description = "Neutron network to use"
    type        = string
    default     = "public-net"
}

variable "os_image_name" {
    description = "Openstack image name for virtual machines"
    type        = string
    default     = "ubuntu-server-24.04"
}

variable "number_control_nodes" {
    description = "Number of nodes for the control plane"
    type        = number
    default     = 1
}

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

variable "worker_node_volume_device" {
    description = "The device to tell the Block Storage service this volume will be attached as"
    type        = string
    default     = "/dev/vdb"
}
