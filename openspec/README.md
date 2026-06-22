# OpenSpec — Vertivo

Decision records (PDR = `proposal.md`, ADR = `design.md`, `tasks.md`) for Vertivo.
Convention ported from `dojocoding/dojo-os` / `chimeranext/better-microservices`.

## Active Changes

| Change | Records | Status |
|---|---|---|
| [`2026-06-01-vertivo-nvidia-physical-ai`](./changes/2026-06-01-vertivo-nvidia-physical-ai/) | proposal · design · tasks | Research spike — 2 digital twins (factory + greenhouse) + synthetic data for vision-core + NVIDIA Inception/Marketplace path |
| [`2026-06-01-dev-bootstrap-hardening`](./changes/2026-06-01-dev-bootstrap-hardening/) | proposal · design · tasks | Proposed — make `make bootstrap-dev` reproducible on a clean host: 3 fixes (H1 Dockerfile Dart pub-workspace · H2 Makefile rollout timeouts/pre-pull · H3 podman `unqualified-search-registries`). H1 → branch `fix/serverpod-dockerfile-pub-workspace`. |
| [`2026-06-21-canonical-flutter-app`](./changes/2026-06-21-canonical-flutter-app/) | proposal · design · tasks | Proposed — `vertivo_flutter` canonical; retire empty `apps/mobile` stub; fix stale `STRUCTURE.md`; mobile arch = Clean Arch + Atomic + Riverpod |
| [`2026-06-21-simulator-control-ui`](./changes/2026-06-21-simulator-control-ui/) | proposal · design · tasks | Proposed — web UI (FastAPI) dev/QA que comanda el simulador de sensores vía MQTT: set-target/anomaly/on-off/kill + calibración (pH fiel 4/7/10, resto estado simple); grid de instrumentos + wiring InterLink interactivo (config-driven). |
| [`2026-06-21-timescaledb-timeseries`](./changes/2026-06-21-timescaledb-timeseries/) | proposal · design · tasks | Proposed — pendiente aprobación — migrar la telemetría de sensores (`environmental_readings`) a TimescaleDB: hypertable particionada por `createdAt` + continuous aggregates 1m/5m/1h para los charts + compresión + retención. SQL custom post-deploy (Serverpod desconoce TimescaleDB). Dev-first. |

> Note: the AI vision engine `vision-core` lives in the `chimeranext/better-microservices`
> monorepo (`openspec/changes/2026-06-01-vision-core/`); this spike is Vertivo's strategy
> that consumes it. A premortem (2026-06-01) flagged: keep this strategy from sprawling —
> the gating risk is vision-core shipping real inference, not the architecture.
