#!/bin/bash

export CONTAINER_DISTRO_NAME="ubuntu"
export CONTAINER_DISTRO_VERSION="jammy"
export OPENSTACK_RELEASE=2025.1
export FEATURES="${OPENSTACK_RELEASE} ubuntu_jammy"
export OVERRIDES_DIR=$(pwd)/overrides
export CEPH_OSD_DATA_DEVICE="/dev/vdb"
export POD_NETWORK_CIDR="10.244.0.0/16"
