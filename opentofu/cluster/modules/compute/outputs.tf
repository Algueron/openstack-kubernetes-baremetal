output "control_plane_hostname" {
  value = openstack_compute_instance_v2.control_plane_node[*].name
}

output "control_plane_ip" {
  value = openstack_compute_instance_v2.control_plane_node[*].access_ip_v4
}

output "worker_hostname" {
  value = openstack_compute_instance_v2.worker_node[*].name
}

output "worker_ip" {
  value = openstack_compute_instance_v2.worker_node[*].access_ip_v4
}
