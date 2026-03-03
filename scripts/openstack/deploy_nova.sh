#!/bin/bash

set -xe

. env.sh

helm upgrade --install nova openstack-helm/nova \
    --namespace=openstack \
    --set bootstrap.wait_for_computes.enabled=true \
    --set conf.ceph.enabled=true \
    --set conf.nova.libvirt.virt_type=qemu \
    --set conf.nova.libvirt.cpu_mode=none \
    $(helm osh get-values-overrides -p ${OVERRIDES_DIR} -c nova ${FEATURES})
