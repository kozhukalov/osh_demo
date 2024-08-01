#!/bin/bash

set -xe

. env.sh

openstack stack show "heat-public-net-deployment" || \
  openstack stack create --wait \
    --parameter network_name=${PUB_NET_NAME} \
    --parameter physical_network_name=public \
    --parameter subnet_name=${PUB_SUBNET_NAME} \
    --parameter subnet_cidr=${PUB_SUBNET} \
    --parameter subnet_gateway=${PUB_BR_EX_ADDR%/*} \
    --parameter allocation_pool_start=${PUB_ALLOCATION_POOL_START} \
    --parameter allocation_pool_end=${PUB_ALLOCATION_POOL_END} \
    -t ${HEAT_DIR}/heat-public-net-deployment.yaml \
    heat-public-net-deployment
