# OpenSpec — Vertivo

Decision records (PDR = `proposal.md`, ADR = `design.md`, `tasks.md`) for Vertivo.
Convention ported from `dojocoding/dojo-os` / `chimeranext/better-microservices`.

## Active Changes

| Change | Records | Status |
|---|---|---|
| [`2026-06-01-vertivo-nvidia-physical-ai`](./changes/2026-06-01-vertivo-nvidia-physical-ai/) | proposal · design · tasks | Research spike — 2 digital twins (factory + greenhouse) + synthetic data for vision-core + NVIDIA Inception/Marketplace path |

> Note: the AI vision engine `vision-core` lives in the `chimeranext/better-microservices`
> monorepo (`openspec/changes/2026-06-01-vision-core/`); this spike is Vertivo's strategy
> that consumes it. A premortem (2026-06-01) flagged: keep this strategy from sprawling —
> the gating risk is vision-core shipping real inference, not the architecture.
