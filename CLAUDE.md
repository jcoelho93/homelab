# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal K3s homelab on Hetzner Cloud. Cluster provisioned via `hetzner-k3s`, services deployed declaratively with Helmfile. Secrets encrypted at rest with SOPS + age.

## Common Commands

```bash
# Provision or update the K3s cluster
make create-k3s          # runs: hetzner-k3s create --config homelab.yaml

# Preview and deploy Helm releases
make diff                # runs: helmfile diff
make apply               # runs: helmfile apply

# Secret management (currently hardcoded to charts/cal-diy/secrets.yaml)
make encrypt             # sops --encrypt --in-place charts/cal-diy/secrets.yaml
make decrypt             # sops charts/cal-diy/secrets.yaml
```

Environment variables (`HCLOUD_TOKEN`, `KUBECONFIG`) are loaded automatically via direnv from `.envrc`. Kubeconfig is stored at `~/.kube/homelab`.

## Architecture

- **`homelab.yaml`** — Cluster spec: single CAX11 master (`cax11`) in Hetzner `nbg1`, K3s `v1.35.4+k3s1`, etcd datastore, workloads scheduled on the master (no worker pool). kubeContext: `homelab-master1`.
- **`helmfile.yaml`** — Declares all Helm releases:
  - `traefik` (kube-system) — ingress controller; TLS via Let's Encrypt with deSEC DNS challenge; HTTP→HTTPS redirect; reads `DESEC_TOKEN` from a `desec-credentials` Secret.
  - `metrics-server` (kube-system)
  - `grafana` (default) — exposed at `grafana.jlab.dedyn.io`; reads Postgres credentials from a secret mounted at `/etc/secrets/postgres`.
  - `postgres-operator` + `postgres-operator-ui` (postgres-operator namespace; UI depends on operator).
- **`values/`** — Helm values overrides per release (e.g. `traefik.yaml`, `grafana.yaml`).
- **`charts/`** — Local Helm charts (e.g. `cal-diy`). Each chart may have a `secrets.yaml` that must be encrypted before committing.

## Networking & TLS

The cluster is exposed via Traefik using host ports 80/443 (no LoadBalancer Service). TLS certificates are issued by Let's Encrypt using the deSEC DNS-01 challenge provider. The domain is `jlab.dedyn.io`.

## Secret Management

Secrets use SOPS with age encryption. The `.sops.yaml` creation rule matches any `.yaml`/`.yml` file. The age public key is stored there. To encrypt a new secrets file:

```bash
sops --encrypt --in-place <path-to-secrets.yaml>
```

The gitignore excludes `.env`, `.envrc`, and `charts/**/secrets.yaml` — never commit plaintext secrets.
