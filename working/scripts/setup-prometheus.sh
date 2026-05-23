#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

source .venv/bin/activate

PASSWORDS_FILE="etc/kolla/passwords.yml"

# Add newly-required keys when services are enabled later in lifecycle.
if ! grep -q '^prometheus_haproxy_user:' "$PASSWORDS_FILE"; then
  printf '\nprometheus_haproxy_user: prometheus\n' >> "$PASSWORDS_FILE"
fi

if ! grep -q '^prometheus_haproxy_password:' "$PASSWORDS_FILE"; then
  prometheus_haproxy_password="$(python - <<'PY'
import secrets
print(secrets.token_urlsafe(32))
PY
)"
  printf 'prometheus_haproxy_password: %s\n' "$prometheus_haproxy_password" >> "$PASSWORDS_FILE"
fi

if [[ -n "${BASTION_HOST:-}" ]]; then
  bastion_user="${BASTION_USER:-ubuntu}"
  ssh_common_args="-o ProxyJump=${bastion_user}@${BASTION_HOST}"
  export EXTRA_OPTS="${EXTRA_OPTS:-} -e ansible_ssh_common_args='${ssh_common_args}'"
fi

ansible-playbook -i inventory/multinode playbooks/setup-prometheus.yml

