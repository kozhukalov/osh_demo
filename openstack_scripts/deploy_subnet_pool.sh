#!/bin/bash

set -xe

. env.sh

openstack stack show "heat-subnet-pool-deployment" || \
  openstack stack create --wait \
    --parameter subnet_pool_name=${PRIVATE_SUBNET_POOL_NAME} \
    --parameter subnet_pool_prefixes=${PRIVATE_SUBNET_POOL} \
    --parameter subnet_pool_default_prefix_length=${PRIVATE_SUBNET_POOL_DEF_PREFIX} \
    -t ${HEAT_DIR}/heat-subnet-pool-deployment.yaml \
    heat-subnet-pool-deployment
