# Vertivo × NVIDIA — Physical AI strategy (two digital twins + Marketplace) — research spike

**Date:** 2026-06-01
**Owner:** Andrés (andres@dojocoding.io)
**Status:** Research spike — synthesized from a 4-agent analysis; pending owner direction
**Domain:** `vision-core` (better-microservices) + Vertivo strategy (vertivolatam)
**Tracking issue:** _to be created (`service:cross-repo`)_

---

## Why (Problem)

Vertivo (autonomous hydroponic greenhouses) wants to (a) **list on the NVIDIA
Enterprise Marketplace**, and (b) use **NVIDIA Omniverse + Isaac Sim** for digital
twins. Two distinct twins emerged: the **factory** that manufactures the greenhouses
(owner's original intent) and the **greenhouses** themselves (the product). Both ride
the same stack (OpenUSD/Isaac Sim/PhysX), and the greenhouse twin directly unblocks
`vision-core`'s declared cold-start bottleneck (no labeled pest/disease data yet).

## What (Decisions & recommendations)

| # | Decision / recommendation | Rationale |
|---|---|---|
| 1 | **NVIDIA Marketplace = via Metropolis partner program, not self-serve.** Enter through **NVIDIA Inception (apply now)** → mature `vision-core` → Metropolis → validation → listing. **~9–18 mo**, gated by vision-core maturity. | Marketplace is the Metropolis ecosystem showcase; listing is partner-gated. |
| 2 | **Confirm the Agriculture/Smart-Spaces vertical with the NVIDIA rep — NOT Smart Cities.** | Industry mismatch; AgTech ≠ Smart Cities. |
| 3 | **Twin A — Factory** (manufacturing plant): Omniverse USD layout + Isaac Sim (Conveyor Utility, Articulation arms, ROS2 Nav AMRs) + **virtual commissioning via OpenPLC↔Modbus HIL**. | Discrete, fast automation → PLC/Modbus is the right fit here. Strong investor de-risking. |
| 4 | **Twin B — Greenhouse** (product): Isaac Sim **Replicator → synthetic COCO data → vision-core** (cold-start); **NuRec** for photorealism from real scans later. | Solves vision-core's labeled-data bottleneck; precedent: sim-to-real fruit detection (Isaac Sim → YOLO → Jetson Orin NX). |
| 5 | **Greenhouse control: DO NOT adopt OpenPLC as the brain. Extend Vertivo's custom MQTT orchestrator with a closed-loop control + actuator layer** (the real gap). Modbus only as edge adapter + HIL interface. | Slow process dynamics; crop recipe IP already in Python; Balena/EMQX backbone superior for multi-site C2. |
| 6 | **The actuator layer is the true critical path** (raspberry `hardware/` is 100% sensors, 0 actuators). EZO-PMP peristaltic pump = lowest-friction first actuator (same I2C bus, `write_data` already exists). | "Autonomy" is blocked on actuation + safety interlocks, not on simulation. |
| 7 | **New capability `vision-core-sdg`** — an **offline** synthetic-data pipeline in better-microservices (NOT a runtime service, NOT Vertivo-side). Couples via the existing `ObjectStoragePort`/MinIO/Kubeflow. | Zero changes to vision-core; synthetic COCO is just "another producer of the dataset bucket". |
| 8 | **Compute: a dedicated RTX nodepool** (Isaac Sim needs RT Cores — **A100/H100 do NOT work**). Isaac Sim is Apache-2.0, free for internal R&D. | Hard requirement, separate from the A100/H100 training cluster. |
| 9 | **First HIL hop = MQTT bridge** (Isaac Sim publishes to the real EMQX with a simulated `greenhouse_id`). Modbus HIL and ROS2 come later. | Reuses 100% of the stack; cheapest, fastest validation. |
| 10 | **OpenUSD asset library is shared** across both twins; **`vision-core` can run E5 (visual QA) on the factory line** (dogfooding + synthetic defect data). | One engineering hour serves factory + product + pitch. |

## Inception — concrete on-ramp (CR Tech Week 2026 deck)

The owner has the **Costa Rica Tech Week 2026 NVIDIA Inception LATAM deck**, presented
by **Andrei Golfeto (Inception LATAM lead)** — the same NVIDIA contact already engaged.
This de-risks the whole Marketplace path:

- **Vertivo meets all 4 Inception eligibility criteria** (deck, verbatim): ≥1 developer ·
  functional website · officially incorporated · <10 years old. No cohorts/fees/deadlines/equity.
  **Apply now: `nvidia.com/startups`.**
- **Benefits that hit Vertivo's exact gatings:** preferred HW pricing (Jetson Orin scarcity),
  **free cloud credits from NCPs/hyperscalers** (run Kubeflow training + Isaac Sim SDG with no
  CapEx), `build.nvidia.com` GPU sandbox incl. **RTX Pro 6000 96 GB** (the RT-Cores GPU Isaac
  Sim needs), 1000+ SDKs/NIMs, DLI courses, **VC connections + investor pitches** (VC Alliance,
  50 LatAm VCs).
- **Fit confirmed by NVIDIA LatAm 2026 stats:** Agriculture = Top-5 dev industry (#4),
  Computer Vision = Top-5 workload (#3), Simulation = Top-5 (#5). Vertivo sits at the intersection.
- **Direct action:** reach out to Andrei Golfeto (Inception LATAM, LinkedIn in deck) + apply to Inception.

## Scope

**In scope (this spike):** the strategy + architecture above as a decision record;
defining `vision-core-sdg` as a future change; the greenhouse-control recommendation
(Vertivo-side); the Marketplace/Inception path.

**Out of scope:** implementing any of it. Each phase below becomes its own change.
NIM-packaging, robotics (Moveo/gantry), and NuRec realism are later phases.

## Open questions for the owner

1. Resolve the 3 reference Marketplace listings (JS SPA — open in browser / chrome-devtools-mcp to name the comps).
2. Apply to NVIDIA Inception now? (free, Vertivo qualifies — incorporated, <10y).
3. Greenhouse: confirm "extend custom orchestrator, not OpenPLC-as-brain".
4. Where does `vision-core-sdg` live — `services/vision-core/sdg/` vs a sibling `tools/synthetic-data/`?
5. Budget a single RTX workstation to start the SDG spike?

## References

- ADR: [`design.md`](./design.md) · Tasks: [`tasks.md`](./tasks.md)
- vision-core: `openspec/changes/2026-06-01-vision-core/`
- Synthesized from 4 research agents (Marketplace · greenhouse-twin/SDG · factory-twin · OSS-automation), 2026-06-01.
