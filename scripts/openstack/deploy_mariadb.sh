#!/bin/bash

set -xe

. env.sh

helm upgrade --install mariadb openstack-helm-infra/mariadb \
    --namespace=openstack \
    --set pod.replicas.server=1 \
    $(helm osh get-values-overrides -p ${OVERRIDES_DIR} -c mariadb ${FEATURES})

helm osh wait-for-pods openstack
