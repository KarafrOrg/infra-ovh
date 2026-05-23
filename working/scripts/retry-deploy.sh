#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

attempt=1
while true; do
  echo "=== Deploy attempt ${attempt} ==="
  if ./scripts/deploy.sh; then
    echo "Deployment succeeded on attempt ${attempt}."
    break
  fi

  echo "Deployment failed on attempt ${attempt}. Retrying in 20 seconds..."
  attempt=$((attempt + 1))
  sleep 20
done

