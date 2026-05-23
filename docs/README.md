# infra-ovh
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/KarafrOrg/infra-ovh)

Infrastructure repository for OVH deployment

## GitHub Actions maintenance workflows

- `openstack-maintenance.yml` provides manual maintenance operations and a weekly scheduled precheck.
- Supported manual operations include bootstrap, deploy, upgrade, wireguard-only, prepare-hosts, prometheus reconfigure, and cloudflare tunnel setup.
- The workflow uses existing Ansible playbooks and roles under `ansible/playbooks` and `ansible/roles`.

Required repository secrets:

- `ANSIBLE_PRIVATE_KEY`
- `OPENSTACK_KOLLA_PROM_REMOTE_WRITE_URL`
- `OPENSTACK_KOLLA_PROM_REMOTE_WRITE_USERNAME`
- `OPENSTACK_KOLLA_PROM_REMOTE_WRITE_PASSWORD`
- `CLOUDFLARE_TUNNEL_TOKEN` (only when running `cloudflare-tunnel` with `token` mode)

Additional workflow:

- `ansible-syntax.yml` runs syntax checks for all supported Ansible playbooks on pull requests.

