#!/bin/bash

set -xe

. env.sh

CHARTS="
rabbitmq
mariadb
memcached
openvswitch
libvirt
keystone
heat
glance
cinder
placement
nova
neutron
horizon
"

OVERRIDES_URL=https://opendev.org/openstack/openstack-helm/raw/branch/master/values_overrides
for chart in $CHARTS; do
    echo helm osh get-values-overrides -d -u ${OVERRIDES_URL} -p ${OVERRIDES_DIR} -c ${chart} ${FEATURES}
done

