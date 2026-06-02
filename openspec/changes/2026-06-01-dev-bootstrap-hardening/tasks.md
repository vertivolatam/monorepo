# Dev-bootstrap hardening — Tasks

> From a real `make bootstrap-dev` run on a clean host. Three independent fixes.
> Status: **documented; H1 landing in `fix/serverpod-dockerfile-pub-workspace`, H2/H3 pending.**

## H1 — Dockerfile + Dart pub-workspace (branch `fix/serverpod-dockerfile-pub-workspace`)
- [ ] `build-backend-image-minikube.sh`: set the `podman build` **context to `$PROJECT_ROOT`** (not `$SERVER_DIR`).
- [ ] `apps/vertivo_server/Dockerfile`: copy workspace root `pubspec.yaml` + `pubspec.lock` + every member `pubspec.yaml` **before** `dart pub get`.
- [ ] Then copy the backend source and `dart pub get --offline` / `dart compile exe` from `apps/vertivo_server`.
- [ ] Verify: `podman build` succeeds and `dart pub get` no longer errors `exit 66 "found no workspace root"`.
- [ ] Verify: `vertivo-backend` pod reaches `Running` (no `ImagePullBackOff`).

## H2 — Makefile timeouts + pre-pull
- [ ] `dev-postgres-deploy`: `rollout status … --timeout=300s`.
- [ ] `dev-backend-deploy` + `dev-backend-restart`: `rollout status … --timeout=420s`.
- [ ] `images-pull`: also `podman pull pgvector/pgvector:pg16` (currently only kicbase).
- [ ] Document: run `make images-pull` before first `make bootstrap-dev` / after `podman system prune`.
- [ ] Verify: clean-host `make bootstrap-dev` no longer aborts while the deploy is actually progressing.

## H3 — Podman registries prerequisite
- [ ] `make setup`: detect missing/commented `unqualified-search-registries` and print the fix hint (via `log_warn`).
- [ ] Document prerequisite: `~/.config/containers/registries.conf` with `unqualified-search-registries = ["docker.io"]`.
- [ ] Verify: on a host without it, `make setup` warns with the exact remediation line.

## Cross-cutting
- [ ] Keep using `infrastructure/scripts/lib/common.sh` logging (ported from altrupets) for all new messages (`log_step`/`log_warn`).
- [ ] Final: a from-zero `make bootstrap-dev` on a clean host reaches a green dev env end-to-end.
- [ ] Link the OpenSpec PR + the Linear `VRTV` issue + the `fix/serverpod-dockerfile-pub-workspace` PR to each other.
