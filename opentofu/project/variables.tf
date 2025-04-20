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
