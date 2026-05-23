#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

source .venv/bin/activate

PASSWORDS_FILE="etc/kolla/passwords.yml"

# Ensure all current release keys exist.
kolla-genpwd -p "$PASSWORDS_FILE"

# Kolla templates may reference valkey password even when valkey is disabled.
if ! grep -q '^valkey_master_password:' "$PASSWORDS_FILE"; then
  valkey_master_password="$(python - <<'PY'
import secrets
print(secrets.token_urlsafe(32))
PY
)"
  printf '\nvalkey_master_password: %s\n' "$valkey_master_password" >> "$PASSWORDS_FILE"
fi

# Octavia worker requires these files under etc/kolla/config/octavia/:
# - client.cert-and-key.pem
# - client_ca.cert.pem
# - server_ca.cert.pem
# - server_ca.key.pem
kolla-ansible octavia-certificates \
  -i inventory/multinode \
  --configdir ./etc/kolla \
  --passwords ./etc/kolla/passwords.yml

# Work around MariaDB 10.11 crash on migration e37941b010db multi-table UPDATE.
# This applies an equivalent data fix and advances only that migration step.
ssh ubuntu@198.27.70.67 "auth=\$(sudo awk '/wsrep_sst_auth/ {print \$3}' /etc/kolla/mariadb/galera.cnf); pw=\${auth#root:}; sudo docker exec -e MYSQL_PWD=\"\$pw\" mariadb mysql -uroot -Nse \"INSERT IGNORE INTO octavia.flavor_profile (id, name, provider_name, flavor_data) VALUES ('00000000-0000-0000-0000-000000000000','DELETED-PLACEHOLDER','DELETED','{}'); INSERT IGNORE INTO octavia.flavor (id, name, description, enabled, flavor_profile_id) VALUES ('00000000-0000-0000-0000-000000000000','DELETED-PLACEHOLDER','Placeholder for DELETED LBs with DELETED flavors',0,'00000000-0000-0000-0000-000000000000'); UPDATE octavia.load_balancer lb SET lb.flavor_id='00000000-0000-0000-0000-000000000000' WHERE lb.flavor_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM octavia.flavor f WHERE f.id=lb.flavor_id); UPDATE octavia.alembic_version SET version_num='e37941b010db' WHERE version_num='dcf88e59aae4';\""

kolla-ansible reconfigure \
  -i inventory/multinode \
  --configdir ./etc/kolla \
  --passwords ./etc/kolla/passwords.yml \
  --tags octavia \
  --limit openstack-node1

