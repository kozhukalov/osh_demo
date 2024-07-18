#!/usr/bin/env python

import argparse
import json
import sys

import jone


def get_vm_ips():
    '''Returns the list of node IPs.
    Reimplements according to your needs.
    '''
    return jone.get_vm_ips()


def one_inventory(pretty=False):
    hostvars = {"_meta": {"hostvars": {}}}
    ips = get_vm_ips()
    primary_names = ["primary"]
    cluster_names = [f"node-{i}" for i in range(1, len(ips))]

    for vm in zip(primary_names + cluster_names, ips):
        vm_name = vm[0]
        vm_ip = vm[1]
        hostvars["_meta"]["hostvars"][vm_name] = {"ansible_host": vm_ip}

    groups = {
        "all": {
            # "vars": {
            #     "ansible_user": "root",
            #     "ansible_ssh_private_key_file": "/home/vlad/.ssh/id_ed25519",
            #     "ansible_ssh_extra_args": "-o StrictHostKeyChecking=no",
            #     "kubectl": {
            #         "user": "root",
            #         "group": "root",
            #     },
            #     "docker_users": ["root"],
            #     "metallb_setup": True,
            #     "openstack_provider_gateway_setup": True,
            #     "client_cluster_ssh_setup": True,
            #     "client_ssh_user": "root",
            #     "cluster_ssh_user": "root",
            #     "calico_setup" : False,
            #     "flannel_setup": True,
            #     "kubeadm": {
            #         "pod_network_cidr": "10.244.0.0/16",
            #         "service_cidr": "10.96.0.0/16",
            #     },
            # },
            "children": [
                "primary",
                "k8s_cluster",
                "k8s_control_plane",
                "k8s_nodes",
            ],
        },
        "primary": {
            "hosts": primary_names,
        },
        "k8s_cluster": {
            "hosts": cluster_names,
        },
        "k8s_control_plane": {
            "hosts": cluster_names[:1],
        },
        "k8s_nodes": {
            "hosts": cluster_names[1:],
        },
    }

    inventory_data = {}
    inventory_data.update(hostvars)
    inventory_data.update(groups)

    indent = None
    if pretty:
        indent = 4
    return json.dumps(inventory_data, indent=indent)


if __name__ == '__main__':

    arg_parser = argparse.ArgumentParser( description=__doc__, prog=__file__)
    arg_parser.add_argument(
        '--pretty',
        action='store_true',
        default=False,
        help="Pretty print JSON"
    )
    options = arg_parser.add_mutually_exclusive_group()
    options.add_argument('--list', action='store', nargs="*")
    options.add_argument('--host', action='store')

    try:
        args = arg_parser.parse_args()
        if args.host:
            print(json.dumps({"_meta":{}}))
            sys.stderr.write('This script already provides _meta via --list, so this option is really ignored\n')
        elif len(args.list) >= 0:
            inventory_data = one_inventory(args.pretty)
            print(inventory_data)
        else:
            raise ValueError("Valid options are --list or --host <HOSTNAME>")

    except ValueError:
        raise
