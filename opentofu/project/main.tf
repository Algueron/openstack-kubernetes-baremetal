
resource "openstack_identity_project_v3" "os_project" {
  name        = var.os_project_name
  description = "Generated Kubernetes cluster"
}

resource "openstack_identity_user_v3" "os_user" {
  default_project_id = openstack_identity_project_v3.os_project.id
  name               = var.os_username
  description        = "Openstack user for Kubernetes project"

  password = var.os_password

  ignore_change_password_upon_first_use = true

  multi_factor_auth_enabled = false
}

data "openstack_identity_role_v3" "member" {
  name = "member"
}

resource "openstack_identity_role_assignment_v3" "os_role_assignment" {
  user_id    = openstack_identity_user_v3.os_user.id
  project_id = openstack_identity_project_v3.os_project.id
  role_id    = data.openstack_identity_role_v3.member.id
}

resource "openstack_compute_quotaset_v2" "quotaset_1" {
  project_id           = openstack_identity_project_v3.os_project.id
  instances            = 15
  cores                = 32
  ram                  = 131072
  security_groups      = 20
  security_group_rules = 200
}

resource "openstack_compute_flavor_v2" "kubernetes-control-flavor" {
  name  = "kubernetes-control"
  vcpus = var.control_node_vcpus
  ram   = var.control_node_memory_mb
  disk  = var.control_node_root_disk_size_gb
}

resource "openstack_compute_flavor_access_v2" "control-flavor-access" {
  tenant_id = openstack_identity_project_v3.os_project.id
  flavor_id = openstack_compute_flavor_v2.kubernetes-control-flavor.id
}

resource "openstack_compute_flavor_v2" "kubernetes-worker-flavor" {
  name  = "kubernetes-worker"
  vcpus = var.worker_node_vcpus
  ram   = var.worker_node_memory_mb
  disk  = var.worker_node_root_disk_size_gb
}

resource "openstack_compute_flavor_access_v2" "worker-flavor-access" {
  tenant_id = openstack_identity_project_v3.os_project.id
  flavor_id = openstack_compute_flavor_v2.kubernetes-worker-flavor.id
}
