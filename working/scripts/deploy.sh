#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# kolla-ansible helper scripts expect GNU readlink and GNU getopt on macOS.
for p in \
  /opt/homebrew/opt/coreutils/libexec/gnubin \
  /usr/local/opt/coreutils/libexec/gnubin \
  /opt/homebrew/opt/gnu-getopt/bin \
  /usr/local/opt/gnu-getopt/bin; do
  if [[ -d "$p" ]]; then
    export PATH="$p:$PATH"
  fi
done

set +e
getopt --test >/dev/null 2>&1
getopt_rc=$?
set -e
if [[ $getopt_rc -ne 4 ]]; then
  echo "GNU getopt is required. Install it with: brew install gnu-getopt" >&2
  exit 1
fi

PYTHON_BIN="${PYTHON_BIN:-}"
if [[ -z "$PYTHON_BIN" ]]; then
  for candidate in /opt/homebrew/bin/python3 /usr/local/bin/python3 python3.12 python3.11 python3.10 python3; do
    if command -v "$candidate" >/dev/null 2>&1; then
      if "$candidate" -c 'import sys; raise SystemExit(0 if sys.version_info >= (3, 10) else 1)'; then
        PYTHON_BIN="$candidate"
        break
      fi
    fi
  done
fi

if [[ -z "$PYTHON_BIN" ]]; then
  echo "Python 3.10+ is required. Install one and rerun (or set PYTHON_BIN)." >&2
  exit 1
fi

"$PYTHON_BIN" -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt

umask 077
touch etc/kolla/passwords.yml
chmod 600 etc/kolla/passwords.yml

if [ ! -s "etc/kolla/passwords.yml" ] || ! grep -q "^[a-zA-Z0-9_].*:" etc/kolla/passwords.yml; then
  kolla-genpwd -p ./etc/kolla/passwords.yml
fi

ANSIBLE_SSH_ARGS=()
if [[ -n "${BASTION_HOST:-}" ]]; then
  bastion_user="${BASTION_USER:-ubuntu}"
  ssh_common_args="-o ProxyJump=${bastion_user}@${BASTION_HOST}"
  ANSIBLE_SSH_ARGS=(--ssh-common-args "$ssh_common_args")
  export EXTRA_OPTS="${EXTRA_OPTS:-} -e ansible_ssh_common_args='${ssh_common_args}'"
fi

ansible-playbook -i inventory/multinode "${ANSIBLE_SSH_ARGS[@]}" playbooks/bootstrap-wireguard.yml
ansible-playbook -i inventory/multinode "${ANSIBLE_SSH_ARGS[@]}" playbooks/prepare-hosts.yml
kolla-ansible bootstrap-servers -i inventory/multinode --configdir ./etc/kolla --passwords ./etc/kolla/passwords.yml
kolla-ansible prechecks -i inventory/multinode --configdir ./etc/kolla --passwords ./etc/kolla/passwords.yml
kolla-ansible pull -i inventory/multinode --configdir ./etc/kolla --passwords ./etc/kolla/passwords.yml
kolla-ansible deploy -i inventory/multinode --configdir ./etc/kolla --passwords ./etc/kolla/passwords.yml
kolla-ansible post-deploy -i inventory/multinode --configdir ./etc/kolla --passwords ./etc/kolla/passwords.yml

echo "Deployment completed. OpenStack RC file: /etc/kolla/admin-openrc.sh"



