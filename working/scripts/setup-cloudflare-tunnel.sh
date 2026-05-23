#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

source .venv/bin/activate

MODE="${CLOUDFLARE_TUNNEL_MODE:-token}"
TOKEN="${CLOUDFLARE_TUNNEL_TOKEN:-}"
HORIZON_URL="${CLOUDFLARE_HORIZON_ORIGIN_URL:-http://10.200.0.1:80}"

if [[ -n "${BASTION_HOST:-}" ]]; then
  bastion_user="${BASTION_USER:-ubuntu}"
  ssh_common_args="-o ProxyJump=${bastion_user}@${BASTION_HOST}"
fi

extra_vars=(
  -e "cloudflare_tunnel_mode=${MODE}"
  -e "cloudflare_horizon_origin_url=${HORIZON_URL}"
)

if [[ "$MODE" == "token" ]]; then
  if [[ -z "$TOKEN" ]]; then
    echo "CLOUDFLARE_TUNNEL_TOKEN is required when CLOUDFLARE_TUNNEL_MODE=token" >&2
    exit 1
  fi
  extra_vars+=( -e "cloudflare_tunnel_token=${TOKEN}" )
fi

if [[ -n "${BASTION_HOST:-}" ]]; then
  ansible-playbook -i inventory/multinode --ssh-common-args "$ssh_common_args" playbooks/setup-cloudflare-tunnel.yml "${extra_vars[@]}"
else
  ansible-playbook -i inventory/multinode playbooks/setup-cloudflare-tunnel.yml "${extra_vars[@]}"
fi


