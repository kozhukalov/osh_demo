#!/bin/bash

set -xe

. env.sh

helm upgrade --install memcached openstack-helm-infra/memcached \
    --namespace=openstack \
    $(helm osh get-values-overrides -p ${OVERRIDES_DIR} -c memcached ${FEATURES})

helm osh wait-for-pods openstack
