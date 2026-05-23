---
name: config-build
description: Build and validate Kolla-Ansible configuration safely from stock templates, with explicit customization diffs and ordered deployment stages.
license: MIT
---

# Config Build

Use this skill when asked to create, repair, or review Kolla-Ansible configuration before first deployment.

## Use these local resources

- `getting-started.md` - canonical first-deploy checklist and rationale.

## Required workflow

1. Confirm target Kolla-Ansible/OpenStack release and read release notes.
2. Copy stock templates (`globals.yml`, inventory, passwords template) from the installed kolla-ansible share directory.
3. Apply only minimal customizations needed for this environment.
4. Verify real interface names on every host before setting network variables.
5. Generate passwords with `kolla-genpwd` from template.
6. Ensure secrets permissions are strict (`chmod 600` for passwords file).
7. Sync final config to `/etc/kolla/` on the deployment context.
8. Run in order: `bootstrap-servers`, `prechecks`, `pull`, `deploy`, `post-deploy`.

## Guardrails

- Do not author `globals.yml` from scratch when stock template is available.
- Do not skip interface validation.
- Do not continue if prechecks fail; fix root cause first.
- Keep changes reviewable by showing exact file diffs and paths.

## Output expectations

When applying this skill, provide:

- A short checklist plan.
- Exact file paths changed.
- Runnable commands in fenced `bash` blocks.
- A final verification step list.

