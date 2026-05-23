---
name: deploy
description: Deploy Kolla-Ansible environments in a safe, ordered way, including prechecks, known-issue workarounds, and deterministic execution steps.
license: MIT
---

# Deploy

Use this skill for first deployment or redeployment planning and execution.

## Local resources

- `README.md`
- `known-issues-2025.1.md`

## Required behavior

1. Read and apply `known-issues-2025.1.md` when targeting that release family.
2. Enforce deploy order: bootstrap-servers, prechecks, pull, deploy, post-deploy.
3. Surface concrete remediation steps for each failure.
4. Prefer minimal changes and rerun only required stages after fixes.

