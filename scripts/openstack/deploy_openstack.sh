#!/bin/bash

set -xe

. env.sh

deploy_rabbitmq.sh
deploy_mariadb.sh
deploy_memcached.sh
deploy_keystone.sh
deploy_heat.sh
deploy_glance.sh
deploy_cinder.sh
deploy_openvswitch.sh
deploy_libvirt.sh
deploy_placement.sh
deploy_nova.sh
deploy_neutron.sh
deploy_horizon.sh
