#!/usr/bin/env python3
from __future__ import annotations

import hcl2
import ipaddress
import json
import os
import re
import sys
from pathlib import Path

DEFAULT_TFVARS_PATH = "live/karafra-net/terraform.auto.tfvars"
DEFAULT_GROUP_NAME = "ovh_dedicated_servers"
DEFAULT_WIREGUARD_NETWORK = "10.200.0.0/24"
DEFAULT_WIREGUARD_LISTEN_PORT = 51820
DEFAULT_ANSIBLE_USER = "ubuntu"
HYPHENATED_IPV4 = re.compile(r"^\d{1,3}(?:-\d{1,3}){3}$")


def fail(message: str) -> None:
    print(message, file=sys.stderr)
    raise SystemExit(1)


def load_tfvars(tfvars_path: Path) -> dict:
    if not tfvars_path.exists():
        fail(f"Terraform vars file not found: {tfvars_path}")

    with tfvars_path.open("r", encoding="utf-8") as handle:
        return hcl2.load(handle)


def normalize_public_ip(value: str | None) -> str | None:
    if not value:
        return None

    value = clean_wrapped_quotes(value)

    if HYPHENATED_IPV4.fullmatch(value):
        return value.replace("-", ".")

    return value


def clean_wrapped_quotes(value: str) -> str:
    value = value.strip()
    if len(value) >= 2 and value[0] == value[-1] and value[0] in {'"', "'"}:
        return value[1:-1]
    return value


def normalize_host_alias(value: str) -> str:
    return value.replace("-", "_")


def build_inventory() -> dict:
    tfvars_path = Path(os.getenv("TFVARS_PATH", DEFAULT_TFVARS_PATH))
    group_name = os.getenv("WIREGUARD_GROUP_NAME", DEFAULT_GROUP_NAME)
    wireguard_network = ipaddress.ip_network(
        os.getenv("WIREGUARD_NETWORK", DEFAULT_WIREGUARD_NETWORK),
        strict=False,
    )
    wireguard_listen_port = int(
        os.getenv("WIREGUARD_LISTEN_PORT", str(DEFAULT_WIREGUARD_LISTEN_PORT))
    )
    ansible_user = os.getenv("ANSIBLE_SSH_USER", DEFAULT_ANSIBLE_USER)

    tfvars = load_tfvars(tfvars_path)
    dedicated_servers = tfvars.get("dedicated_servers", {})

    if not isinstance(dedicated_servers, dict):
        fail(f"Expected 'dedicated_servers' to be a map in {tfvars_path}")

    source_hosts = sorted(dedicated_servers)
    if len(source_hosts) >= wireguard_network.num_addresses - 1:
        fail(
            f"WireGuard network {wireguard_network} is too small for {len(source_hosts)} hosts"
        )

    hosts: list[str] = []
    hostvars: dict[str, dict] = {}
    for index, source_host_name in enumerate(source_hosts, start=1):
        host_alias = normalize_host_alias(source_host_name)
        if host_alias in hostvars:
            fail(
                f"Normalized host alias '{host_alias}' collides in {tfvars_path}. "
                "Use unique dedicated_servers keys after replacing '-' with '_'."
            )

        server_config = dedicated_servers[source_host_name] or {}
        labels = server_config.get("labels", {}) or {}
        openstack_role = str(labels.get("role") or server_config.get("role") or "").strip().lower()
        raw_public_ip = labels.get("ip") or server_config.get("ip")
        raw_service_name = labels.get("service_name") or server_config.get("service_name")
        public_ip = normalize_public_ip(raw_public_ip)
        service_name = clean_wrapped_quotes(raw_service_name) if raw_service_name else None

        if not public_ip and not service_name:
            fail(
                f"Host '{source_host_name}' is missing both labels.ip and service_name in {tfvars_path}"
            )

        address = wireguard_network.network_address + index
        hosts.append(host_alias)
        hostvars[host_alias] = {
            "ansible_host": public_ip or service_name,
            "ansible_user": ansible_user,
            "ansible_python_interpreter": "/usr/bin/python3",
            "public_ip": public_ip,
            "wireguard_address": f"{address}/{wireguard_network.prefixlen}",
            "wireguard_endpoint": public_ip or service_name,
            "wireguard_listen_port": wireguard_listen_port,
            "wireguard_network": str(wireguard_network),
            "wireguard_service_name": service_name,
            "wireguard_source_host_name": source_host_name,
            "openstack_role": openstack_role,
        }

    return {
        group_name: {
            "hosts": hosts,
            "vars": {
                "wireguard_inventory_group": group_name,
                "wireguard_network": str(wireguard_network),
                "wireguard_listen_port": wireguard_listen_port,
            },
        },
        "_meta": {"hostvars": hostvars},
    }


def render_ssh_config(inventory: dict) -> str:
    hostvars = inventory.get("_meta", {}).get("hostvars", {})
    lines = [
        "Host *",
        "  StrictHostKeyChecking no",
        "  UserKnownHostsFile /dev/null",
    ]

    for host, vars_for_host in sorted(hostvars.items()):
        ansible_host = str(vars_for_host.get("ansible_host") or "").strip()
        ansible_user = str(vars_for_host.get("ansible_user") or DEFAULT_ANSIBLE_USER).strip()
        if not ansible_host:
            continue
        lines.extend(
            [
                f"Host {host}",
                f"  HostName {ansible_host}",
                f"  User {ansible_user}",
            ]
        )

    return "\n".join(lines) + "\n"


def write_ssh_config_file(path_arg: str, inventory: dict) -> None:
    ssh_config_path = Path(path_arg).expanduser()
    ssh_config_path.parent.mkdir(parents=True, exist_ok=True)
    ssh_config_path.write_text(render_ssh_config(inventory), encoding="utf-8")
    os.chmod(ssh_config_path, 0o600)


def main() -> None:
    args = list(sys.argv[1:])
    write_ssh_config_path = None
    if "--write-ssh-config" in args:
        index = args.index("--write-ssh-config")
        if index + 1 >= len(args):
            fail("--write-ssh-config requires a file path argument")
        write_ssh_config_path = args[index + 1]
        del args[index:index + 2]

    inventory = build_inventory()

    if write_ssh_config_path:
        write_ssh_config_file(write_ssh_config_path, inventory)

    if "--host" in args:
        host_index = args.index("--host") + 1
        host_name = args[host_index] if host_index < len(args) else ""
        print(json.dumps(inventory.get("_meta", {}).get("hostvars", {}).get(host_name, {})))
        return

    print(json.dumps(inventory, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
