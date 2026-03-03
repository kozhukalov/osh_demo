#!/bin/bash

set -xe

. env.sh


tee ${OVERRIDES_DIR}/cinder/values_overrides/cinder_pools.yaml <<EOF
conf:
  ceph:
    pools:
      backup:
        replication: 1
        crush_rule: replicated_rule
        chunk_size: 8
        app_name: cinder-backup
      cinder.volumes:
        replication: 1
        crush_rule: replicated_rule
        chunk_size: 8
        app_name: cinder-volume
EOF

helm upgrade --install cinder openstack-helm/cinder \
    --namespace=openstack \
    --timeout=600s \
    $(helm osh get-values-overrides -p ${OVERRIDES_DIR} -c cinder cinder_pools ${FEATURES})
helm osh wait-for-pods openstack
