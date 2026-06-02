# Dev-bootstrap hardening — make `make bootstrap-dev` robust & reproducible

**Date:** 2026-06-01
**Owner:** Andrés (andres@dojocoding.io)
**Status:** Proposed — from a real `make bootstrap-dev` run on a clean host (3 reproducible failures)
**Domain:** `infrastructure/` (dev bootstrap, minikube, Serverpod backend image)
**Tracking issue:** Linear `VRTV` — `[infra] Dev-bootstrap hardening` (see ADR for the 3 fixes)
**Related branch:** `fix/serverpod-dockerfile-pub-workspace` (another agent is landing the Dockerfile fix, H1)

---

## Why (Problem)

A from-scratch `make bootstrap-dev` on a clean machine does **not** reach a green dev
environment. Three independent, reproducible failures stop it — two are hard blockers
(no backend image is ever produced), one is a false-negative abort (the deploy actually
succeeds but the bootstrap reports failure). The flow is meant to be the canonical
"one-liner from zero to running GitOps dev env", so every one of these breaks the
promise of reproducibility for a new contributor.

Observed on a real run:

| # | Symptom | Effect |
|---|---|---|
| **H1** | `dart pub get` in the backend image fails: `Could not find a file named "pubspec.yaml"` / **"found no workspace root"** (`exit 66`) | Backend image never builds → `vertivo-backend` pod stuck in `ImagePullBackOff`. Hard blocker. |
| **H2** | `kubectl rollout status … --timeout=120s` times out on the **first** image pull (pgvector pg16 took **3m8s**) | Bootstrap aborts even though the deploy finishes fine. False-negative blocker. |
| **H3** | Podman can't resolve short image names (`dart:3.8.0`, `alpine:latest`) — `unqualified-search-registries` is commented out in `/etc/containers/registries.conf` | `podman build` fails before H1 is even reached. Hard blocker, host-config. |

## What (Decisions & recommendations)

| # | Decision | Rationale |
|---|---|---|
| 1 | **H1 — Make the backend image workspace-aware.** The Dockerfile must copy the **workspace root `pubspec.yaml` + `pubspec.lock` + every member `pubspec.yaml`** before `dart pub get`, and the build context must include the repo root. Fixed in `fix/serverpod-dockerfile-pub-workspace`. | `apps/vertivo_server/pubspec.yaml` is `resolution: workspace`; Dart needs the workspace root in the image to resolve. |
| 2 | **H2 — Raise rollout timeouts to 300–420s and pre-pull heavy images.** Bump the `--timeout=120s` on postgres + backend rollouts; extend `images-pull` to pull pgvector pg16 (not just kicbase). | First pull of large images legitimately exceeds 120s; the deploy is healthy, only the gate is wrong. |
| 3 | **H3 — Document the podman registries prerequisite and check it in `make setup`.** `make setup` should detect a missing/commented `unqualified-search-registries` and emit a fix hint; document it in prerequisites. | Host-level config the bootstrap silently depends on; a clear hint saves a new contributor a blind failure. |

## Scope

**In scope (this change):** documenting the 3 fixes as a decision record (PDR + ADR + tasks);
the Dockerfile workspace-copy pattern (H1, landing in a sibling branch); the Makefile timeout
+ `images-pull` changes (H2); the `make setup` registries check + prerequisites doc (H3).

**Out of scope:** Serverpod app code; the GitOps/Argo layer beyond the bootstrap gates;
any change to production image builds (this is dev-bootstrap only).

## References

- ADR: [`design.md`](./design.md) · Tasks: [`tasks.md`](./tasks.md)
- Touched files: `apps/vertivo_server/Dockerfile`, `infrastructure/scripts/build-backend-image-minikube.sh`, `Makefile`, `infrastructure/scripts/lib/common.sh`
- Sibling branch (H1): `fix/serverpod-dockerfile-pub-workspace`
