#!/bin/bash

set -x

apt install -y docker.io

docker run -d --name dnsmasq_jinr --restart always \
    --cap-add=NET_ADMIN \
    --network=host \
    --entrypoint dnsmasq \
    docker.io/openstackhelm/neutron:2024.1-ubuntu_jammy \
    --keep-in-foreground \
    --no-hosts \
    --bind-interfaces \
    --auth-server=ns1.openstack.jinr.ru,eth0 \
    --auth-zone=openstack.jinr.ru \
    --auth-soa=202408151200 \
    --auth-sec-servers=ns2.openstack.jinr.ru \
    --host-record=ns1.openstack.jinr.ru,10.220.27.0 \
    --host-record=ns2.openstack.jinr.ru,10.220.27.0 \
    --listen-address="10.220.27.0" \
    --no-resolv \
    --server=159.93.14.7

echo "nameserver 10.220.27.0" > /etc/resolv.conf
