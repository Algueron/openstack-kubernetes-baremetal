resource "openstack_networking_secgroup_v2" "allow-ssh" {
  name        = "allow-ssh"
  description = "Security Group for SSH connection"
}

resource "openstack_networking_secgroup_rule_v2" "ssh-secgroup-rule" {
  description       = "SSH"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.allow-ssh.id
}

resource "openstack_networking_secgroup_v2" "kubernetes-control-plane" {
  name        = "kubernetes-master"
  description = "Security Group for Kubernetes Master nodes"
}

resource "openstack_networking_secgroup_rule_v2" "kubernetes-api-server" {
  description       = "Kubernetes API server"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6443
  port_range_max    = 6443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.kubernetes-control-plane.id
}

resource "openstack_networking_secgroup_rule_v2" "etcd-server" {
  description       = "etcd server client API"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 2979
  port_range_max    = 2980
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.kubernetes-control-plane.id
}

resource "openstack_networking_secgroup_rule_v2" "kubelet-api" {
  description       = "Kubelet API"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10250
  port_range_max    = 10250
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.kubernetes-control-plane.id
}

resource "openstack_networking_secgroup_rule_v2" "kube-scheduler" {
  description       = "kube-scheduler"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10259
  port_range_max    = 10259
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.kubernetes-control-plane.id
}

resource "openstack_networking_secgroup_rule_v2" "kube-controller-manager" {
  description       = "kube-controller-manager"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10257
  port_range_max    = 10257
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.kubernetes-control-plane.id
}

resource "openstack_networking_secgroup_v2" "kubernetes-worker-node" {
  name        = "kubernetes-node"
  description = "Security Group for Kubernetes Compute nodes"
}

resource "openstack_networking_secgroup_rule_v2" "kubelet-api-worker" {
  description       = "Kubelet API"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10250
  port_range_max    = 10250
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.kubernetes-worker-node.id
}

resource "openstack_networking_secgroup_rule_v2" "kube-proxy" {
  description       = "kube-proxy"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10256
  port_range_max    = 10256
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.kubernetes-worker-node.id
}

resource "openstack_networking_secgroup_rule_v2" "kube-nodeport" {
  description       = "NodePort Services"
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 30000
  port_range_max    = 32767
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.kubernetes-worker-node.id
}
