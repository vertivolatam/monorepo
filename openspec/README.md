# OpenSpec — Vertivo

Decision records (PDR = `proposal.md`, ADR = `design.md`, `tasks.md`) for Vertivo.
Convention ported from `dojocoding/dojo-os` / `chimeranext/better-microservices`.

## Active Changes

| Change | Records | Status |
|---|---|---|
| [`2026-06-01-vertivo-nvidia-physical-ai`](./changes/2026-06-01-vertivo-nvidia-physical-ai/) | proposal · design · tasks | Research spike — 2 digital twins (factory + greenhouse) + synthetic data for vision-core + NVIDIA Inception/Marketplace path |
| [`2026-06-01-dev-bootstrap-hardening`](./changes/2026-06-01-dev-bootstrap-hardening/) | proposal · design · tasks | Proposed — make `make bootstrap-dev` reproducible on a clean host: 3 fixes (H1 Dockerfile Dart pub-workspace · H2 Makefile rollout timeouts/pre-pull · H3 podman `unqualified-search-registries`). H1 → branch `fix/serverpod-dockerfile-pub-workspace`. |
| [`2026-06-21-crop-explorer-redesign`](./changes/2026-06-21-crop-explorer-redesign/) | proposal · design · tasks | Proposed (VRTV-96) — rediseño del crop_explorer PySide6: sidebar (búsqueda+filtros+chip discrepancias) \| detalle (Datos Botánicos · Negocio editable con Guardar→audit · 4 tabs de fase con `InstrumentCard` compartido con el simulador + árbol de receta) + extracción de datos nutricionales. |

> Note: the AI vision engine `vision-core` lives in the `chimeranext/better-microservices`
> monorepo (`openspec/changes/2026-06-01-vision-core/`); this spike is Vertivo's strategy
> that consumes it. A premortem (2026-06-01) flagged: keep this strategy from sprawling —
> the gating risk is vision-core shipping real inference, not the architecture.
