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

variable "control_plane_flavor" {
    description = "Flavor to use for control plane nodes"
    type        = string
    default     = "t2.medium"
}

variable "number_worker_nodes" {
    description = "Number of worker nodes"
    type        = number
    default     = 3
}

variable "worker_node_flavor" {
    description = "Flavor to use for worker nodes"
    type        = string
    default     = "t2.2xlarge"
}

variable "rook_volume_ids" {
    description = "Ids of the volumes provisoned for Rook"
    type        = list
}

variable "worker_node_volume_device" {
    description = "The device to tell the Block Storage service this volume will be attached as"
    type        = string
    default     = "/dev/vdb"
}
