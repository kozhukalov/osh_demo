# Clone repo
```bash
cd ~
git clone https://github.com/kozhukalov/osh_demo.git
```

# Clone repos with necessary ansible roles
```bash
mkdir -p ~/osh
cd ~/osh
git clone https://opendev.org/openstack/openstack-helm-infra.git
git clone https://opendev.org/zuul/zuul-jobs.git
```

# Prepare venv
```bash
cd ~/osh_demo
python -m venv osh_demo_venv
source osh_demo_venv/bin/activate
pip install ansible
```

# Prepare Ansible inventory

## Way 1: inventory.yaml
Edit `ansible/inventory.yaml` file and set node IPs.

## Way 2: inventory.py
Edit `ansible/inventory.py` and implement `get_vm_ips` function which must return the list of IPs. The default implementation uses jone python module which is a wrapper for pyone (OpenNebula).
```bash
pip install git+https://github.com/kozhukalov/jone.git
mkdir -p ~/.config/jone
tee ~/.config/jone/config <<EOF
endpoint: "https://cloud.provider.tld/RPC2"
username: "username"
password: "password"
EOF
```

# Prepare inventory variables
Edit the `ansible/group_vars/all.yaml` file and set necessary variables. Default variables are [here](https://opendev.org/openstack/openstack-helm-infra/src/branch/master/roles/deploy-env/defaults/main.yaml)


# Deploy K8s
```bash
cd ~/osh_demo/ansible
export ANSIBLE_ROLES_PATH=~/osh/openstack-helm-infra/roles:~/osh/zuul-jobs/roles
# upgrade OS if necessary
ansible-playbook -i inventory.py playbooks/upgrade.yaml
# deploy K8s
ansible-playbook -i inventory.py playbooks/deploy-env.yaml
# or use the following command depending on the inventory format
# ansible-playbook -i inventory.yaml playbooks/deploy-env.yaml
```

# Sync scripts
```bash
cd ~/osh_demo
rsync -rlt scripts root@$<primary_ip>:
```

## Run scripts
Connect via ssh to primary node:
```bash
ssh root@<primary_1>
```

and run the following:
```bash
cd ~/scripts
./prepare_k8s.sh
./prepare_helm.sh
./prepare_overrides.sh
./deploy_ingress.sh
./deploy_ceph.sh
./deploy_ceph-adapter-rook.sh
./deploy_metallb.sh
./deploy_openstack.sh
./deploy_openstack_public_endpoint.sh
```
