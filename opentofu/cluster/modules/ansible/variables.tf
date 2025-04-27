variable "number_control_nodes" {
    description = "Number of nodes for the control plane"
    type        = number
    default     = 1
}

variable "control_plane_hostname" {
    type        = list
}

variable "control_plane_ip" {
    type        = list
}

variable "number_worker_nodes" {
    description = "Number of worker nodes"
    type        = number
    default     = 3
}

variable "worker_hostname" {
    type        = list
}

variable "worker_ip" {
    type        = list
}
