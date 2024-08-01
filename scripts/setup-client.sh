#!/bin/bash

set -xe

. env.sh

sudo -H mkdir -p /etc/openstack
sudo -H chown -R $(id -un): /etc/openstack
tee /etc/openstack/clouds.yaml << EOF
clouds:
  openstack_helm:
    region_name: RegionOne
    identity_api_version: 3
    auth:
      username: 'admin'
      password: 'password'
      project_name: 'admin'
      project_domain_name: 'default'
      user_domain_name: 'default'
      auth_url: 'http://keystone.openstack.svc.cluster.local/v3'
EOF

sudo tee /usr/local/bin/openstack << EOF
#!/bin/bash
args=("\$@")

: \${OS_CLOUD:=openstack_helm}
: \${OPENSTACK_RELEASE:=2024.1}

sudo docker run \\
    --rm \\
    --network host \\
    -w / \\
    -v /etc/openstack/clouds.yaml:/etc/openstack/clouds.yaml \\
    -v /etc/openstack-helm:/etc/openstack-helm \\
    -e OS_CLOUD=\${OS_CLOUD} \\
    \${OPENSTACK_CLIENT_CONTAINER_EXTRA_ARGS} \\
    docker.io/openstackhelm/openstack-client:\${OPENSTACK_RELEASE} openstack "\${args[@]}"
EOF
sudo chmod +x /usr/local/bin/openstack
