# OpenSpec — Vertivo

Decision records (PDR = `proposal.md`, ADR = `design.md`, `tasks.md`) for Vertivo.
Convention ported from `dojocoding/dojo-os` / `chimeranext/better-microservices`.

## Active Changes

| Change | Records | Status |
|---|---|---|
| [`2026-06-01-vertivo-nvidia-physical-ai`](./changes/2026-06-01-vertivo-nvidia-physical-ai/) | proposal · design · tasks | Research spike — 2 digital twins (factory + greenhouse) + synthetic data for vision-core + NVIDIA Inception/Marketplace path |
| [`2026-06-01-dev-bootstrap-hardening`](./changes/2026-06-01-dev-bootstrap-hardening/) | proposal · design · tasks | Proposed — make `make bootstrap-dev` reproducible on a clean host: 3 fixes (H1 Dockerfile Dart pub-workspace · H2 Makefile rollout timeouts/pre-pull · H3 podman `unqualified-search-registries`). H1 → branch `fix/serverpod-dockerfile-pub-workspace`. |
| [`2026-06-21-crop-explorer-redesign`](./changes/2026-06-21-crop-explorer-redesign/) | proposal · design · tasks | Implemented (VRTV-96) — rediseño del crop_explorer PySide6: sidebar (búsqueda+filtros+chip discrepancias) \| detalle (Datos Botánicos · Negocio editable con Guardar→audit · 4 tabs de fase con `InstrumentCard` compartido con el simulador + árbol de receta) + tabla `nutrition` (extractor sheet-first; grupo verde vacío en la hoja → semilla `researched` USDA para cultivos insignia). |
| [`2026-06-21-crop-explorer-megatabs`](./changes/2026-06-21-crop-explorer-megatabs/) | proposal · design · tasks · **mockup** | Proposed — diseño visual APROBADO (brainstorm + visual companion): 3 mega-tabs (Catálogo \| Perfiles & Recetas \| Calculadora de lote). La receta es del **perfil×fase** (editar propaga a N cultivos, auditado); convención "g de sal seca / 1000 ml de agua" (sin aforar, la sal desplaza volumen) + switch de vista "Aforado a 1 L"; **calculadora de lote** = solver inverso por envase del catálogo (Pichinga/Tanque) + densidades por sal. Dual-target: PySide6 crop_explorer **y** vertivo_dashboard web. Mockup interactivo en `mockups/`. |
| [`2026-06-21-canonical-flutter-app`](./changes/2026-06-21-canonical-flutter-app/) | proposal · design · tasks | Proposed — `vertivo_flutter` canonical; retire empty `apps/mobile` stub; fix stale `STRUCTURE.md`; mobile arch = Clean Arch + Atomic + Riverpod |
| [`2026-06-21-simulator-control-ui`](./changes/2026-06-21-simulator-control-ui/) | proposal · design · tasks | Proposed — web UI (FastAPI) dev/QA que comanda el simulador de sensores vía MQTT: set-target/anomaly/on-off/kill + calibración (pH fiel 4/7/10, resto estado simple); grid de instrumentos + wiring InterLink interactivo (config-driven). |

> Note: the AI vision engine `vision-core` lives in the `chimeranext/better-microservices`
> monorepo (`openspec/changes/2026-06-01-vision-core/`); this spike is Vertivo's strategy
> that consumes it. A premortem (2026-06-01) flagged: keep this strategy from sprawling —
> the gating risk is vision-core shipping real inference, not the architecture.
