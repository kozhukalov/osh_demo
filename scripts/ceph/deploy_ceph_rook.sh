#!/bin/bash

set -xe

# Specify the Rook release tag to use for the Rook operator here
ROOK_RELEASE=v1.17.3

#NOTE: Deploy command
tee /tmp/rook.yaml <<EOF
image:
  repository: rook/ceph
  tag: ${ROOK_RELEASE}
  pullPolicy: IfNotPresent
crds:
  enabled: true
nodeSelector: {}
tolerations: []
unreachableNodeTolerationSeconds: 5
currentNamespaceOnly: false
annotations: {}
logLevel: INFO
rbacEnable: true
pspEnable: false
priorityClassName:
allowLoopDevices: true
csi:
  enableRbdDriver: true
  enableCephfsDriver: false
  enableGrpcMetrics: false
  enableCSIHostNetwork: true
  enableCephfsSnapshotter: true
  enableNFSSnapshotter: true
  enableRBDSnapshotter: true
  enablePluginSelinuxHostMount: false
  enableCSIEncryption: false
  pluginPriorityClassName: system-node-critical
  provisionerPriorityClassName: system-cluster-critical
  rbdFSGroupPolicy: "File"
  cephFSFSGroupPolicy: "File"
  nfsFSGroupPolicy: "File"
  enableOMAPGenerator: false
  cephFSKernelMountOptions:
  enableMetadata: false
  provisionerReplicas: 1
  clusterName: ceph
  logLevel: 0
  sidecarLogLevel:
  rbdPluginUpdateStrategy:
  rbdPluginUpdateStrategyMaxUnavailable:
  cephFSPluginUpdateStrategy:
  nfsPluginUpdateStrategy:
  grpcTimeoutInSeconds: 150
  allowUnsupportedVersion: false
  csiRBDPluginVolume:
  csiRBDPluginVolumeMount:
  csiCephFSPluginVolume:
  csiCephFSPluginVolumeMount:
  provisionerTolerations:
  provisionerNodeAffinity: #key1=value1,value2; key2=value3
  pluginTolerations:
  pluginNodeAffinity: # key1=value1,value2; key2=value3
  enableLiveness: false
  cephfsGrpcMetricsPort:
  cephfsLivenessMetricsPort:
  rbdGrpcMetricsPort:
  csiAddonsPort:
  forceCephFSKernelClient: true
  rbdLivenessMetricsPort:
  kubeletDirPath:
  cephcsi:
    image:
  registrar:
    image:
  provisioner:
    image:
  snapshotter:
    image:
  attacher:
    image:
  resizer:
    image:
  imagePullPolicy: IfNotPresent
  cephfsPodLabels: #"key1=value1,key2=value2"
  nfsPodLabels: #"key1=value1,key2=value2"
  rbdPodLabels: #"key1=value1,key2=value2"
  csiAddons:
    enabled: false
    image: "quay.io/csiaddons/k8s-sidecar:v0.5.0"
  nfs:
    enabled: false
  topology:
    enabled: false
    domainLabels:
  readAffinity:
    enabled: false
    crushLocationLabels:
  cephFSAttachRequired: true
  rbdAttachRequired: true
  nfsAttachRequired: true
enableDiscoveryDaemon: false
cephCommandsTimeoutSeconds: "15"
useOperatorHostNetwork:
discover:
  toleration:
  tolerationKey:
  tolerations:
  nodeAffinity: # key1=value1,value2; key2=value3
  podLabels: # "key1=value1,key2=value2"
  resources:
disableAdmissionController: true
hostpathRequiresPrivileged: false
disableDeviceHotplug: false
discoverDaemonUdev:
imagePullSecrets:
enableOBCWatchOperatorNamespace: true
admissionController:
EOF

helm repo add rook-release https://charts.rook.io/release
helm install --create-namespace --namespace rook-ceph rook-ceph rook-release/rook-ceph --version ${ROOK_RELEASE} -f /tmp/rook.yaml
helm osh wait-for-pods rook-ceph
