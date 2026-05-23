---
name: day-two
description: Run day-2 Kolla-Ansible operations such as upgrades, post-deploy changes, and maintenance workflows with explicit risk checks.
license: MIT
---

# Day Two Operations

Use this skill for lifecycle tasks after initial deployment, especially upgrades.

## Local resources

- `README.md`
- `upgrade-2025.1-to-2025.2.md`

## Required behavior

1. Identify current and target release before proposing actions.
2. Follow the upgrade runbook in `upgrade-2025.1-to-2025.2.md` when that path matches.
3. Require backups/checkpoints before disruptive actions.
4. Use staged commands with validation after each stage.
5. Stop and report clearly on first failed precheck.

