#!/bin/bash

set -xe

. env.sh

INSTANCE_ID=$(openstack stack output show \
    heat-basic-vm-deployment \
    instance_uuid \
    -f value -c output_value)

openstack stack show "heat-vm-volume-attach" || \
  openstack stack create --wait \
      --parameter instance_uuid=${INSTANCE_ID} \
      -t ${HEAT_DIR}/heat-vm-volume-attach.yaml \
      heat-vm-volume-attach
