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
| [`2026-06-21-dashboard-fleet-cockpit`](./changes/2026-06-21-dashboard-fleet-cockpit/) | proposal · design · tasks | **Approved (2026-06-21) — en implementación.** Cablear `vertivo_dashboard` (Jaspr + D3) como cockpit de flota **cross-tenant (operador admin)**: dep `vertivo_client`, repositories, 6 pages → endpoints reales (`getReadings`, `alert.*`, `anomaly.*`, `cropCatalog.*`) + **1 endpoint admin nuevo `adminFleet.listAll`** (`Scope.admin`, excepción aprobada a "no new endpoints"), puerto Jaspr→:8090, InstrumentCard para rangos. Issue: VRTV-99. |
| [`2026-06-21-timescaledb-timeseries`](./changes/2026-06-21-timescaledb-timeseries/) | proposal · design · tasks | OQs RESUELTAS — pendiente aprobación de merge — migrar la telemetría de sensores (`environmental_readings`) a TimescaleDB: hypertable (`timescale/timescaledb-ha:pg16`+pgvector) con **chunk de 1 día** + continuous aggregates **1m/5m/1h/1d** (el 1d jerárquico, sobrevive al drop de crudos) + compresión >7d + retención >90d. **Desacople del ORM Serverpod (Opción 3):** se quita `table:` del modelo (resuelve el conflicto de PK de raíz); el hypertable lo posee un Job SQL idempotente; ingesta + lectura por SQL crudo. **DEV + PROD** (StatefulSet/PVC + ventana de mantenimiento). Es la **costura (Fase 1)** del strangler hacia `timeseries_core` (`chimeranext/better-microservices` #76). |

> Note: the AI vision engine `vision-core` lives in the `chimeranext/better-microservices`
> monorepo (`openspec/changes/2026-06-01-vision-core/`); this spike is Vertivo's strategy
> that consumes it. A premortem (2026-06-01) flagged: keep this strategy from sprawling —
> the gating risk is vision-core shipping real inference, not the architecture.
