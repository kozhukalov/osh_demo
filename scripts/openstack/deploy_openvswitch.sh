#!/bin/bash

set -xe

. env.sh

helm upgrade --install openvswitch openstack-helm-infra/openvswitch \
    --namespace=openstack \
    $(helm osh get-values-overrides -p ${OVERRIDES_DIR} -c openvswitch ${FEATURES})
helm osh wait-for-pods openstack
