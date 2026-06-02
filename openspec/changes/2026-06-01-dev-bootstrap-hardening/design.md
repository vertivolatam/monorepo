# Dev-bootstrap hardening — Architecture / fixes

**Issue:** Linear `VRTV` — `[infra] Dev-bootstrap hardening`
**Status:** Design 2026-06-01 (from a real `make bootstrap-dev` run)
**Related branch:** `fix/serverpod-dockerfile-pub-workspace` (H1)
**PDR:** [`proposal.md`](./proposal.md)

## TL;DR

Three independent failures break a clean-host `make bootstrap-dev`: (H1) the Serverpod
backend Dockerfile is not Dart-pub-workspace-aware, (H2) the `kubectl rollout status`
timeouts are too short for the first heavy image pull, and (H3) Podman has no
`unqualified-search-registries`. H1 + H3 are hard blockers (no image ever builds);
H2 is a false-negative abort (the deploy is healthy, the gate is wrong). The bootstrap
already inherits the structured logging library ported from altrupets
(`infrastructure/scripts/lib/common.sh`), so the fixes are about correctness, not
observability.

---

## H1 — Dockerfile vs. Dart pub-workspace

**Root cause.** The repo root `pubspec.yaml` declares a Dart **pub workspace**:

```yaml
# pubspec.yaml (repo root)
name: vertivo_workspace
workspace:
  - apps/vertivo_server
  - apps/vertivo_client
  - apps/vertivo_flutter
  - apps/vertivo_dashboard
```

and the backend member opts into it:

```yaml
# apps/vertivo_server/pubspec.yaml
name: vertivo_server
resolution: workspace
```

With `resolution: workspace`, `dart pub get` walks **upward** looking for the workspace
root `pubspec.yaml` (the one with the `workspace:` key). The build, however, only gives
the image the app subtree:

- `infrastructure/scripts/build-backend-image-minikube.sh` does `cd "$PROJECT_ROOT"`
  (with the comment *"Build from workspace root so Dart workspace resolution works"*) but
  then sets the **build context to `"$SERVER_DIR"`** (`apps/vertivo_server`), so the
  workspace root is **not** in the context.
- `apps/vertivo_server/Dockerfile` does `COPY . .` → only the app lands in the image →
  `dart pub get` finds no `workspace:` root → **`Could not resolve … found no workspace
  root`, exit 66** → the build stage dies → no image → pod `ImagePullBackOff`.

**Fix (landing in `fix/serverpod-dockerfile-pub-workspace`).** Make the image
workspace-aware. The build context must be the **repo root**, and the Dockerfile must
copy the workspace root manifests + every member `pubspec.yaml` *before* the dependency
resolution, then the app source, so the layer cache still works:

```dockerfile
FROM dart:3.8.0 AS build
WORKDIR /app
# 1) workspace root manifest + lock + every member pubspec (cache-friendly)
COPY pubspec.yaml pubspec.lock ./
COPY apps/vertivo_server/pubspec.yaml   apps/vertivo_server/
COPY apps/vertivo_client/pubspec.yaml   apps/vertivo_client/
COPY apps/vertivo_flutter/pubspec.yaml  apps/vertivo_flutter/
COPY apps/vertivo_dashboard/pubspec.yaml apps/vertivo_dashboard/
RUN dart pub get
# 2) the backend source
COPY apps/vertivo_server/ apps/vertivo_server/
WORKDIR /app/apps/vertivo_server
RUN dart pub get --offline
RUN dart compile exe bin/main.dart -o bin/server
```

and the build script passes the repo root as context:

```bash
# build-backend-image-minikube.sh
podman build -t "${IMAGE_TAG}" -f "$SERVER_DIR/Dockerfile" "$PROJECT_ROOT"
```

(Flutter-only members can be reduced to a stub pubspec if pulling Flutter into the Dart
image is undesirable; the key is that the workspace root + the members the resolver
touches are present.)

## H2 — Makefile rollout timeouts too short

**Root cause.** The bootstrap gates deploys on `kubectl rollout status … --timeout=120s`:

- `dev-postgres-deploy` → `kubectl rollout status deployment/postgres … --timeout=120s`
- `dev-backend-deploy` / `dev-backend-restart` → `… deployment/vertivo-backend … --timeout=120s`

On a clean host, the **first** pull of the pgvector pg16 image took **3m8s** (188s) —
well past 120s. The Deployment becomes Ready shortly after, but `rollout status` has
already returned non-zero, so the bootstrap aborts on a healthy cluster.

**Fix.**
1. Raise the rollout timeouts to **300s (postgres)** and **420s (backend)** — the backend
   also waits on migrations on first boot.
2. Extend `images-pull` (today it only pulls `gcr.io/k8s-minikube/kicbase`) to **pre-pull
   the heavy third-party images** (pgvector pg16) so the first deploy doesn't pay the pull
   cost under the rollout gate. Document running `make images-pull` before the first
   `make bootstrap-dev` / after `podman system prune`.

```makefile
# dev-postgres-deploy
@kubectl rollout status deployment/postgres -n $(NAMESPACE) --timeout=300s
# dev-backend-deploy / dev-backend-restart
@kubectl rollout status deployment/vertivo-backend -n $(NAMESPACE) --timeout=420s

# images-pull
images-pull:
	podman pull gcr.io/k8s-minikube/kicbase:v0.0.50
	podman pull pgvector/pgvector:pg16
```

## H3 — Podman `unqualified-search-registries`

**Root cause.** `/etc/containers/registries.conf` ships with `unqualified-search-registries`
commented out. Podman then refuses to resolve **short image names** — the Dockerfile uses
`FROM dart:3.8.0` and `FROM alpine:latest`, both unqualified — so `podman build` fails
before H1 is even reached.

**Fix (host-level, already applied for the run).** Put a per-user override at
`~/.config/containers/registries.conf` so `docker.io` is searched:

```toml
unqualified-search-registries = ["docker.io"]
```

**Fix (repo-level, what this change adds).** The bootstrap silently depends on this host
config, so:
1. Add a check in the `make setup` prerequisites target that detects a missing/commented
   `unqualified-search-registries` and prints the exact hint above.
2. Document the prerequisite in the README/dev docs.

```makefile
# setup: add to the prerequisite checks
@podman info --format '{{.Registries}}' 2>/dev/null | grep -q docker.io \
	&& echo "$(GREEN)  podman registries$(NC)" \
	|| echo "$(YELLOW)  podman: add unqualified-search-registries=[\"docker.io\"] to ~/.config/containers/registries.conf$(NC)"
```

## Logging — already ported from altrupets

`infrastructure/scripts/lib/common.sh` already provides the structured logging contract
ported from altrupets — `log_error/log_warn/log_info/log_success/log_debug`, `log_step
<current> <total> <msg>`, `log_header`, level gating via `LOG_LEVEL`, and consistent
color/emoji output. The bootstrap scripts should keep using it so each of the three fixes
surfaces a clear, leveled message (e.g. `log_warn` + remediation hint for H3 in `setup`,
`log_step` around the longer postgres/backend waits for H2) rather than a bare non-zero exit.

## Why these belong together

All three are surfaced by the **same** `make bootstrap-dev` run and all three must be
fixed for it to be reproducible on a clean host: H3 unblocks the build, H1 makes the build
succeed, H2 stops a healthy deploy from being reported as a failure. Documenting them as
one change keeps the "from zero to green" story coherent.

## Risks

| Risk | Mitigation |
|---|---|
| H1: pulling Flutter members into the Dart backend image bloats it | copy only the pubspecs needed for resolution; stub Flutter-only members if needed |
| H2: longer timeouts mask a genuinely stuck deploy | timeouts are an upper bound, not a sleep; a truly failed rollout still exits non-zero at 300/420s |
| H3: per-user `registries.conf` not portable to CI | `make setup` check + docs make the requirement explicit; CI images can bake the system config |

## References
- PDR: [`proposal.md`](./proposal.md) · Tasks: [`tasks.md`](./tasks.md)
- Files: `apps/vertivo_server/Dockerfile`, `infrastructure/scripts/build-backend-image-minikube.sh`, `Makefile`, `infrastructure/scripts/lib/common.sh`
- Sibling branch (H1): `fix/serverpod-dockerfile-pub-workspace`
- Real run: pgvector pg16 first pull = 3m8s; `dart pub get` exit 66 "found no workspace root"
