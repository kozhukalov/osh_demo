#!/bin/bash

set -xe

helm upgrade --install ceph-adapter-rook openstack-helm-infra/ceph-adapter-rook \
  --namespace=openstack

helm osh wait-for-pods openstack
