#!/bin/bash

set -xe

. env.sh

tee ${OVERRIDES_DIR}/glance/values_overrides/glance_pvc_storage.yaml <<EOF
storage: pvc
volume:
  class_name: general
  size: 5Gi
EOF

helm upgrade --install glance openstack-helm/glance \
    --namespace=openstack \
    $(helm osh get-values-overrides -p ${OVERRIDES_DIR} -c glance glance_pvc_storage ${FEATURES})
helm osh wait-for-pods openstack
