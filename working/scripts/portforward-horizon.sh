#!/usr/bin/env bash
set -euo pipefail

# Opens an SSH local port-forward from your laptop to Horizon on the internal VIP.
# Supports optional bastion jump host via BASTION_HOST/BASTION_USER.

CONTROLLER_HOST="${CONTROLLER_HOST:-198.27.70.67}"
CONTROLLER_USER="${CONTROLLER_USER:-ubuntu}"
HORIZON_VIP="${HORIZON_VIP:-10.200.0.1}"
REMOTE_PORT="${REMOTE_PORT:-80}"
LOCAL_PORT="${LOCAL_PORT:-8080}"
BASTION_HOST="${BASTION_HOST:-}"
BASTION_USER="${BASTION_USER:-ubuntu}"

ssh_args=(
  -N
  -L "${LOCAL_PORT}:${HORIZON_VIP}:${REMOTE_PORT}"
  -o ExitOnForwardFailure=yes
  -o ServerAliveInterval=30
  -o ServerAliveCountMax=3
)

if [[ -n "${BASTION_HOST}" ]]; then
  ssh_args+=( -J "${BASTION_USER}@${BASTION_HOST}" )
fi

cat <<EOF
Opening Horizon tunnel:
  local:  http://127.0.0.1:${LOCAL_PORT}
  remote: http://${HORIZON_VIP}:${REMOTE_PORT}
  via:    ${CONTROLLER_USER}@${CONTROLLER_HOST}

Keep this terminal open while using the dashboard.
Press Ctrl+C to stop the tunnel.
EOF

exec ssh "${ssh_args[@]}" "${CONTROLLER_USER}@${CONTROLLER_HOST}"

