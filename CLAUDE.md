# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal K3s homelab on Hetzner Cloud. Cluster provisioned via `hetzner-k3s`, services deployed declaratively with Helmfile. Secrets encrypted at rest with SOPS + age.

## Common Commands

```bash
# Provision or update the K3s cluster
make create-k3s          # runs: hetzner-k3s create --config homelab.yaml

# Deploy/sync all Helm releases
make apply               # runs: helmfile apply

# Secret management
make encrypt             # sops --encrypt --in-place charts/cal-diy/secrets.yaml
make decrypt             # sops charts/cal-diy/secrets.yaml
```

Environment variables (`HCLOUD_TOKEN`, `KUBECONFIG`) are loaded automatically via direnv from `.envrc`. Kubeconfig is stored at `~/.kube/homelab`.

## Architecture

- **`homelab.yaml`** — Cluster spec: single CAX11 master in Hetzner `nbg1`, K3s `v1.35.4+k3s1`, etcd datastore, workloads run on master (no separate worker pool).
- **`helmfile.yaml`** — Declares all Helm releases. Currently: `metrics-server` (kube-system), `postgres-operator` and `postgres-operator-ui` (postgres-operator namespace, UI depends on operator).
- **`secrets/`** — SOPS-encrypted secrets (age key configured in `.sops.yaml`). The gitignore excludes `charts/**/secrets.yaml` — any secrets file in a chart must be encrypted before committing.
- **`charts/`** — Local Helm charts (e.g. `cal-diy`). Each chart may have a `secrets.yaml` that must be encrypted with `make encrypt` before committing.

## Secret Management

Secrets use SOPS with age encryption. The age public key is in `.sops.yaml`. To add a new secret file to a chart, encrypt it with:

```bash
sops --encrypt --in-place <path-to-secrets.yaml>
```

Never commit plaintext `secrets.yaml` files — they are gitignored for this reason.
