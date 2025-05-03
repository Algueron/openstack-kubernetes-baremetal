variable "os_project_name" {
    description = "Openstack project name"
    type        = string
    default     = "kubernetes"
}

variable "os_username" {
    description = "Openstack user login"
    type        = string
    default     = "kubernetes"
}

variable "os_password" {
    description = "Openstack user password"
    type        = string
}

variable "control_node_vcpus" {
    description = "Number of vCPUs for control node flavor"
    type        = number
    default     = 2
}

variable "control_node_memory_mb" {
    description = "Amount of RAM to use, in megabytes, for control node flavor"
    type        = number
    default     = 4096
}

variable "control_node_root_disk_size_gb" {
    description = "The amount of disk space in GiB to use for the root (/) partition for control node flavor"
    type        = number
    default     = 30
}

variable "worker_node_vcpus" {
    description = "Number of vCPUs for worker node flavor"
    type        = number
    default     = 8
}

variable "worker_node_memory_mb" {
    description = "Amount of RAM to use, in megabytes, for worker node flavor"
    type        = number
    default     = 32768
}

variable "worker_node_root_disk_size_gb" {
    description = "The amount of disk space in GiB to use for the root (/) partition for worker node flavor"
    type        = number
    default     = 50
}
