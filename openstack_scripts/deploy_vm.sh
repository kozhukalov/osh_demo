#!/bin/bash

set -xe

. env.sh

IMAGE_NAME=$(openstack image show -f value -c name \
  $(openstack image list -f csv | awk -F ',' '{ print $2 "," $1 }' | \
    grep "^\"Cirros" | head -1 | awk -F ',' '{ print $2 }' | tr -d '"'))

mkdir -p ${SSH_DIR}
openstack keypair show "${VM_KEY_STACK}" || \
  openstack keypair create --private-key ${SSH_DIR}/osh_key ${VM_KEY_STACK}
sudo chown $(id -un) ${SSH_DIR}/osh_key
chmod 600 ${SSH_DIR}/osh_key

openstack stack show "heat-basic-vm-deployment" || \
  openstack stack create --wait \
      --parameter public_net=${PUB_NET_NAME} \
      --parameter image="${IMAGE_NAME}" \
      --parameter ssh_key=${VM_KEY_STACK} \
      --parameter cidr=${PRIVATE_SUBNET} \
      --parameter dns_nameserver=${PUB_BR_EX_ADDR%/*} \
      -t ${HEAT_DIR}/heat-basic-vm-deployment.yaml \
      heat-basic-vm-deployment

FLOATING_IP=$(openstack stack output show \
    heat-basic-vm-deployment \
    floating_ip \
    -f value -c output_value)

INSTANCE_ID=$(openstack stack output show \
    heat-basic-vm-deployment \
    instance_uuid \
    -f value -c output_value)

openstack server show ${INSTANCE_ID}
