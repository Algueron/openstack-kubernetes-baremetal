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

- Copy the public and private key you want t use onto the OpenTofu server
````bash
scp -i opentofu.key ~/.ssh/id_rsa.pub ubuntu@$OPENTOFU_IP:~/.ssh/id_rsa.pub
scp -i opentofu.key ~/.ssh/id_rsa ubuntu@$OPENTOFU_IP:~/.ssh/id_rsa
````

## Openstack Project

- Log in the OpenTofu server
````bash
ssh -i opentofu.key ubuntu@$OPENTOFU_IP
````

- Log to Openstack as Admin
````bash
source admin-openrc.sh
````

- Clone this repository
````bash
git clone https://github.com/Algueron/openstack-kubernetes-baremetal.git
````

- Fill the variable files with a generated Openstack password
````bash
export OS_USER_PASSWORD=$(openssl rand -base64 18)
sed -i -e "s~OS_USER_PASSWORD~$OS_USER_PASSWORD~g" $PWD/openstack-kubernetes-baremetal/project.tfvars
sed -i -e "s~OS_USER_PASSWORD~$OS_USER_PASSWORD~g" $PWD/openstack-kubernetes-baremetal/kubernetes-openrc.sh
````

- Download OpenTofu providers
````bash
tofu -chdir=$PWD/openstack-kubernetes-baremetal/opentofu/project init
````

- Deploy the Openstack project
````bash
tofu -chdir=$PWD/openstack-kubernetes-baremetal/opentofu/project apply -var-file=$PWD/openstack-kubernetes-baremetal/project.tfvars
````

## Kubernetes Cluster

### Openstack Provisioning

- Log to Openstack as Admin
````bash
source $PWD/openstack-kubernetes-baremetal/kubernetes-openrc.sh
````

- Fill the variable file with the pulic key value
````bash
export SSH_PUBLIC_KEY=$(cat ~/.ssh/id_rsa.pub)
sed -i -e "s~SSH_PUBLIC_KEY~$SSH_PUBLIC_KEY~g" $PWD/openstack-kubernetes-baremetal/cluster.tfvars
````

- Download OpenTofu providers and initialize project
````bash
tofu -chdir=$PWD/openstack-kubernetes-baremetal/opentofu/cluster init
````

- Deploy the Openstack project
````bash
tofu -chdir=$PWD/openstack-kubernetes-baremetal/opentofu/cluster apply -var-file=$PWD/openstack-kubernetes-baremetal/cluster.tfvars
````

### Network tweaking

Being L3 CNI, calico and kube-router do not encapsulate all packages with the hosts' ip addresses. Instead the packets will be routed with the PODs ip addresses directly.

OpenStack will filter and drop all packets from ips it does not know to prevent spoofing.

In order to make L3 CNIs work on OpenStack you will need to tell OpenStack to allow pods packets by allowing the network they use.

On the deployment node :

- Log to Openstack as Admin
````bash
source admin-openrc.sh
````

- Allow Kubernetes CIDR on the created ports
````bash
openstack port list --device-owner=compute:nova --project kubernetes -c ID -f value | xargs -tI@ openstack port set @ --allowed-address ip-address=10.233.0.0/18 --allowed-address ip-address=10.233.64.0/18
````

### Kubernetes Setup

- Clone Kubespray repository
````bash
git clone https://github.com/kubernetes-sigs/kubespray.git
cd kubespray/ && git checkout release-2.27 && cd ~/
````

- Install Python venv
````bash
sudo apt install -y python3-venv
````

- Install Python venv
````bash
mkdir ~/python-env
python3 -m venv ~/python-env/kubespray
source ~/python-env/kubespray/bin/activate
````

- Ensure you're using the latest version of PIP
````bash
pip install -U pip
````

- Now we need to install the dependencies for Ansible to run the Kubespray playbook
````bash
pip install -r ~/kubespray/requirements.txt
````

- Move to Kubespray root directory
````bash
cd ~/kubespray
ansible -i ~/openstack-kubernetes-baremetal/kubespray/inventory/mycluster/inventory.ini -m ping all
cd ~/
````

- Deploy Kubernetes
````bash
cd ~/kubespray
ansible-playbook --become -i ~/openstack-kubernetes-baremetal/kubespray/inventory/mycluster/inventory.ini cluster.yml
cd ~/
````

## Post-setup operations
