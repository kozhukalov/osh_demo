#!/bin/bash

set -xe

. env.sh

PROVIDER_INTERFACE=provider1
tee ${OVERRIDES_DIR}/neutron/values_overrides/neutron_simple.yaml << EOF
conf:
  neutron:
    DEFAULT:
      l3_ha: False
      max_l3_agents_per_router: 1
  auto_bridge_add:
    br-ex: ${PROVIDER_INTERFACE}
  plugins:
    ml2_conf:
      ml2_type_flat:
        flat_networks: public
    openvswitch_agent:
      ovs:
        bridge_mappings: public:br-ex
labels:
  agent:
    l3:
      node_selector_key: l3-agent
      node_selector_value: enabled
EOF

helm upgrade --install neutron openstack-helm/neutron \
    --namespace=openstack \
    $(helm osh get-values-overrides -p ${OVERRIDES_DIR} -c neutron neutron_simple ${FEATURES})

helm osh wait-for-pods openstack
