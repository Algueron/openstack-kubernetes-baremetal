
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
