# Simulation setup of Bare Metal Kubernetes on Openstack
This project uses OpenTofu and Ansible (i.e. Kubespray) to install Kubernetes on Openstack.

## Prerequisites

### Environment

You should have :
- a running Openstack cloud (see [this repository](https://github.com/Algueron/openstack-home))
- a server running OpenTofu (see [this repository](https://github.com/Algueron/openstack-opentofu))

### Authentication

From the deployment node :

- Switch to Virtual env
````bash
source ~/kolla/venv/bin/activate
````

- Log as Openstack infrastructure user
````bash
source infra-user-openrc.sh
````

- Retrieve the IP of the OpenTofu server
````bash
OPENTOFU_IP=$(openstack server show opentofu --column addresses --format json | jq --raw-output '.addresses."public-net"[0]')
````

- Copy the admin credentials onto the OpenTofu server
````bash
scp -i opentofu.key /etc/kolla/admin-openrc.sh ubuntu@$OPENTOFU_IP:
````
