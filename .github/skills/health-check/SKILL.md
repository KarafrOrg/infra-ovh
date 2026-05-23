---
name: health-check
description: Validate OpenStack and Kolla-Ansible health after deploy using concise operational checks and clear pass/fail criteria.
license: MIT
---

# Health Check

Use this skill for post-deploy validation and routine health checks.

## Local resources

- `README.md`

## Required behavior

1. Verify control plane reachability and service registration.
2. Verify compute availability and basic workload path.
3. Report failures with exact command output snippets and next fixes.

