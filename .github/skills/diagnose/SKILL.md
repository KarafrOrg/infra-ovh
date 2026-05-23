---
name: diagnose
description: Diagnose failing Kolla-Ansible or OpenStack deployment steps using structured triage and targeted verification commands.
license: MIT
---

# Diagnose

Use this skill when deployment or day-2 commands fail and root-cause analysis is needed.

## Local resources

- `README.md`

## Required behavior

1. Capture the first hard error, not only trailing noise.
2. Classify failure domain (inventory, networking, auth, image pull, service health, version mismatch).
3. Propose smallest safe fix first.
4. Re-run only the necessary command stage to verify resolution.

