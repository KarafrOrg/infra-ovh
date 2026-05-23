# Kolla-Ansible 2-node bootstrap (controller + worker)

This repository contains a minimal, runnable Kolla-Ansible setup for:

- `openstack-node1` (`198.27.70.67`) as **controller + network node**
- `openstack-node2` (`54.36.168.182`) as **compute worker**
- host user: `ubuntu`
- WireGuard mesh (`wg0`) for internal node-to-node communication

## What is configured

- Multinode inventory in `inventory/multinode`
- Host-specific variables in `inventory/host_vars/`
- Kolla globals in `etc/kolla/globals.yml`
- WireGuard provisioning playbook in `playbooks/bootstrap-wireguard.yml`
- Cloudflare tunnel playbook in `playbooks/setup-cloudflare-tunnel.yml`
- Prometheus remote_write playbook in `playbooks/setup-prometheus.yml`
- Octavia enable helper in `scripts/setup-octavia.sh`
- One-shot deploy script in `scripts/deploy.sh`
- Auto-retry deploy loop in `scripts/retry-deploy.sh`

## Prerequisites

Run from a control machine that can SSH to both nodes as `ubuntu`.

- Python 3.10+
- SSH key loaded for both hosts
- Ubuntu hosts with outbound internet access

## Quick start

```bash
cd /Users/matustoth/IdeaProjects/kolla-ansible
rm -rf .venv
chmod +x scripts/deploy.sh scripts/retry-deploy.sh
./scripts/retry-deploy.sh
```

If your nodes are reachable only through a bastion host:

```bash
export BASTION_HOST=<bastion-public-ip-or-dns>
export BASTION_USER=ubuntu
./scripts/retry-deploy.sh
```

## Post-deploy

```bash
source /etc/kolla/admin-openrc.sh
openstack service list
openstack hypervisor list
```

## Expose Horizon via Cloudflare Tunnel

Use a Cloudflare named tunnel token (recommended):

```bash
cd /Users/matustoth/IdeaProjects/kolla-ansible
chmod +x scripts/setup-cloudflare-tunnel.sh
CLOUDFLARE_TUNNEL_MODE=token \
CLOUDFLARE_TUNNEL_TOKEN=<your-cloudflare-tunnel-token> \
./scripts/setup-cloudflare-tunnel.sh
```

If you only need a temporary public URL, use a quick tunnel:

```bash
cd /Users/matustoth/IdeaProjects/kolla-ansible
CLOUDFLARE_TUNNEL_MODE=quick \
./scripts/setup-cloudflare-tunnel.sh
```

The quick tunnel URL is printed by the playbook output.

## Configure Prometheus remote_write (Grafana Cloud)

The Prometheus override template is in `templates/prometheus.yml.j2` and values are set in `inventory/group_vars/all.yml`.

Apply the config and reconfigure only Prometheus services:

```bash
cd /Users/matustoth/IdeaProjects/kolla-ansible
chmod +x scripts/setup-prometheus.sh
./scripts/setup-prometheus.sh
```

## Enable Octavia load balancer

```bash
cd /Users/matustoth/IdeaProjects/kolla-ansible
chmod +x scripts/setup-octavia.sh
./scripts/setup-octavia.sh
```

## Scale out later

To add future compute nodes:

1. add host to `inventory/multinode` under `[compute]` (stock Kolla child groups include it automatically)
2. create `inventory/host_vars/<new-node>.yml` with `ansible_host`, `wireguard_address`, `wireguard_port`, `external_interface`
3. rerun:

```bash
ansible-playbook -i inventory/multinode playbooks/bootstrap-wireguard.yml
kolla-ansible -i inventory/multinode deploy
```

## Notes

- `external_interface` defaults to `ens3` in host vars. Change it if your NIC differs.
- `nova_compute_virt_type` is set to `qemu` for compatibility.
- Passwords are generated into `etc/kolla/passwords.yml` by `kolla-genpwd` when needed.
- Dependency pins are set for `kolla-ansible 21.x` + `openstack_release: 2025.1`.


