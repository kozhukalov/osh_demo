#!/bin/bash

#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

set -xe

. env.sh

tee /tmp/ceph-provisioners.yaml <<EOF
endpoints:
  ceph_mon:
    namespace: ceph
network:
  public: 172.17.0.1/16
  cluster: 172.17.0.1/16
deployment:
  storage_secrets: false
  ceph: false
  csi_rbd_provisioner: false
  client_secrets: true
  rgw_keystone_user_and_endpoints: false
bootstrap:
  enabled: false
conf:
  rgw_ks:
    enabled: false
storageclass:
  rbd:
    parameters:
      adminSecretName: rook-csi-rbd-provisioner
      adminSecretNameNode: rook-csi-rbd-node
      userSecretName: pvc-ceph-client-key
  csi_rbd:
    provisioner: rook-ceph.rbd.csi.ceph.com
    parameters:
      clusterID: ceph
      csi.storage.k8s.io/controller-expand-secret-name: rook-csi-rbd-provisioner
      csi.storage.k8s.io/controller-expand-secret-namespace: ceph
      csi.storage.k8s.io/fstype: ext4
      csi.storage.k8s.io/node-stage-secret-name: rook-csi-rbd-node
      csi.storage.k8s.io/node-stage-secret-namespace: ceph
      csi.storage.k8s.io/provisioner-secret-name: rook-csi-rbd-provisioner
      csi.storage.k8s.io/provisioner-secret-namespace: ceph
      pool: rbd
      imageFeatures: layering
      imageFormat: "2"
      adminId: admin
      adminSecretName: rook-csi-rbd-provisioner
      adminSecretNamespace: ceph
      userId: admin
      userSecretName: pvc-ceph-client-key
EOF

helm upgrade --install ceph-openstack-config openstack-helm-infra/ceph-provisioners \
  --namespace=openstack \
  --values=/tmp/ceph-provisioners.yaml \
  $(helm osh get-values-overrides -p ${OVERRIDES_DIR} -c ceph-provisioners ${FEATURES})

helm osh wait-for-pods openstack
