#!/bin/bash

set -xe

. env.sh

helm upgrade --install horizon openstack-helm/horizon \
    --namespace=openstack \
    $(helm osh get-values-overrides -p ${OVERRIDES_DIR} -c horizon ${FEATURES})

helm osh wait-for-pods openstack
