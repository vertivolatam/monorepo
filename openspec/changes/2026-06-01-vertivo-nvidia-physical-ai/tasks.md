# Vertivo × NVIDIA Physical AI — Tasks

> Phased plan synthesized from the 4-agent analysis. Each phase can become its own change.
> Status: **research spike done; nothing implemented.**

## Phase 0 — Now (free / no-regret moves)
- [ ] **Apply to NVIDIA Inception** (`nvidia.com/startups`) — Vertivo meets all 4 criteria.
- [ ] **Reach out to Andrei Golfeto** (Inception LATAM) — confirm the right Marketplace
      vertical (Agriculture/Smart-Spaces) + the listing process + custom-NIM viability.
- [ ] Create a `build.nvidia.com` account; test the RTX Pro 6000 sandbox for Isaac Sim.
- [ ] Resolve the 3 reference Marketplace listings (chrome-devtools-mcp / browser) to name comps.

## Phase 1 — Synthetic-data spike (highest ROI for vision-core)
- [ ] New change `2026-06-..-vision-core-sdg`: an OFFLINE pipeline (NOT a runtime service).
- [ ] 1 RTX workstation (or sandbox): Isaac Sim headless + minimal USD greenhouse (1 crop, 1 pest).
- [ ] Replicator domain randomization (light/angle/severity) + custom `CocoWriter` → MinIO.
- [ ] Success: the Kubeflow DAG consumes synthetic COCO with **zero vision-core changes**; eval gate runs.
- [ ] Wire a synthetic batch as a second `retrain_trigger`.

## Phase 2 — Greenhouse control (Vertivo-side, unblocks "autonomous")
- [ ] `ControlOrchestrator` + actuator abstraction in `apps/raspberry` (activate `subscribe_to_commands`).
- [ ] First actuator: EZO-PMP peristaltic pump (pH dosing) + local safety interlocks/fail-safe.
- [ ] HIL-MQTT: Isaac Sim publishes to the real EMQX with a simulated `greenhouse_id`.

## Phase 3 — Factory twin (pitch + commissioning)
- [ ] Omniverse USD layout (E1–E6) + Conveyor/Articulation; export BOM + waypoints.
- [ ] PhysX cycle-time/bottleneck sim → plant sizing (units/month, # AMRs/stations).
- [ ] OpenPLC↔Isaac Sim Modbus HIL (pymodbus extension, ~50 Hz); ROS2 for arms/AMRs (BCN3D Moveo URDF).
- [ ] vision-core dogfooding at E5 visual QA (synthetic defect data).

## Phase 4 — Marketplace listing (gated by vision-core maturity)
- [ ] Mature vision-core to a running demo (inference real, not stubs).
- [ ] Package toward NIM / AI-Enterprise; keep RF-DETR Apache-2.0 as shipped default.
- [ ] Metropolis Partner Program → Fleet Command validation → listing.

## Phase 5 — NuRec realism (when a pilot greenhouse exists)
- [ ] Scan a real Vertivo greenhouse → NuRec reconstruction → randomize pests on real background.

## Gated / dependencies
- [ ] RTX nodepool / sandbox (Isaac Sim — A100/H100 don't work).
- [ ] vision-core out of scaffold (`2026-06-01-vision-core` Phase 3+).
