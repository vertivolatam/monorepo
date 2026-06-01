# Vertivo × NVIDIA Physical AI — Architecture

**Issue:** _to be created_ (`service:cross-repo`)
**Status:** Research synthesis 2026-06-01
**Depends on:** `2026-06-01-vision-core` (the CV engine both twins feed/consume)
**PDR:** [`proposal.md`](./proposal.md)

## TL;DR

One shared stack (OpenUSD + Isaac Sim + PhysX + the NVIDIA inference stack vision-core
already uses) serves **two digital twins** (factory + greenhouse) and an **offline
synthetic-data pipeline** that unblocks vision-core. NVIDIA Inception (Vertivo qualifies)
is the on-ramp to the Marketplace listing and the compute credits that fund it.

## 1. Shared foundation (why it's one project, two views)

**OpenUSD is the common asset layer.** The USD models of the IoT controller / PCB /
sensors / plants are authored once and reused by both twins. Isaac Sim (Apache-2.0, free
for internal R&D) provides PhysX, Replicator (SDG), ROS2 bridge, Conveyor/Warehouse
utilities, Articulation (arms), and the Modbus-over-Python HIL path. **Compute gate:**
Isaac Sim needs **RTX with RT Cores — A100/H100 do NOT work**; use an RTX workstation or
`build.nvidia.com` RTX Pro 6000 sandbox, separate from the A100/H100 training cluster.

## 2. Twin A — Factory (manufacturing plant) [original intent]

Virtual commissioning of the plant that builds Vertivo's greenhouse units + IoT controllers.

- **Stations E1–E6:** frame assembly → IoT/PCB pick-and-place → sensor integration →
  firmware flash + connectivity QA → **visual QA (can run vision-core)** → packaging.
- **Material handling:** Isaac Sim Conveyor Belt Utility + Articulation arms + ROS2-Nav AMRs;
  navigation waypoints exported from the USD layout.
- **Virtual commissioning (HIL):** OpenPLC runs IEC 61131-3 logic; Isaac Sim is the Modbus
  client via a **pymodbus loop in a Python extension** (~50 Hz, Articulation API). OmniGraph
  orchestrates; **Modbus for discrete stations/PLC, ROS2 for mobile/arms.** Here OpenPLC is
  the right fit (discrete, fast, deterministic) — unlike the greenhouse (§4).
- **Bottleneck sim:** instrument per-station cycle time vs takt → size buffers / parallel
  stations / AMRs → capacity (units/month) + where NOT to spend CapEx.
- **OSH:** Vention CAD (MachineMotion AI carries an NVIDIA 8 GB processor) · BCN3D Moveo
  (URDF→Isaac Sim) · GRBL/OSMC · OpenMV (E5 QA).
- **Pitch value:** "validated layout, control logic, throughput before buying a machine."

## 3. Twin B — Greenhouse (product) + synthetic data for vision-core

- **Synthetic data (the highest-ROI move):** Isaac Sim **Replicator** authors a USD greenhouse
  with semantically-labelled plants/lesions; domain-randomizes light/angle/**severity**/occlusion;
  annotators emit instance masks + bboxes; a **custom `CocoWriter`** (subclass `Writer`) writes
  COCO to `s3://vision-core-datasets/synthetic/<crop>/<run>/` via the `S3fsObjectStorageAdapter`.
  The **Kubeflow DAG can't tell synthetic from HITL** → zero changes to vision-core. Use **hybrid**
  (synthetic + little real); synthetic-only underperforms (sim-to-real literature).
- **NuRec** (Gaussian splatting): scan a real pilot greenhouse → photorealistic reconstruction →
  randomize pests over a real background → closes the domain gap. Highest-realism move, later phase.
- **No robotics in Vertivo today** → Isaac Sim is an SDG engine here, not a robot simulator (yet).

## 4. Greenhouse control — extend the custom orchestrator, NOT OpenPLC

`raspberry` is **read-only telemetry today** (`subscribe_to_commands` + Atlas `write_data`
exist but are latent; `hardware/` is 100% sensors). Recommendation:
- **Build a closed-loop `ControlOrchestrator` + actuator layer in Python** (the real gap;
  EZO-PMP peristaltic pump = lowest-friction first actuator, same I2C bus). Hysteresis/deadband,
  local safety interlocks (fail-safe if MQTT drops). The crop recipe is Vertivo's IP and lives in Python.
- **Modbus only** as an edge adapter for 3rd-party PLCs and as the HIL interface.
- **First HIL hop = MQTT bridge:** Isaac Sim publishes to the real EMQX with a simulated
  `greenhouse_id` → the controller can't tell sim from plant. Cheapest, reuses 100% of the stack.
  Fidelity ladder: SIL (exists) → HIL-MQTT → HIL-Modbus → mixed physical.

## 5. Marketplace / Inception path

Inception (Vertivo qualifies, Andrei Golfeto is the LATAM contact) → mature vision-core
(the gate: it's stub today) → Metropolis Partner Program → app validation (Fleet Command) →
**listing under Agriculture/Smart-Spaces, NOT Smart Cities** (confirm vertical with rep).
Package vision-core toward NIM/AI-Enterprise conventions; keep **RF-DETR Apache-2.0** as the
shipped default (avoid YOLO AGPL in a distributed artifact). ~9–18 mo, gated by product maturity.

## 6. Where each capability lands

| Capability | Home | Form |
|---|---|---|
| Synthetic data (`vision-core-sdg`) | **better-microservices** | offline pipeline/tool next to vision-core (RTX nodepool) |
| Greenhouse digital twin (USD + Replicator scenes) | better-microservices (`vision-core-sdg/scenes`) | USD assets + Replicator scripts |
| Factory digital twin | **Vertivo** (or a new `tools/factory-twin`) | Omniverse/Isaac project; not a microservice |
| Greenhouse `ControlOrchestrator` + actuators | **Vertivo** (`apps/raspberry`) | Python control layer (Vertivo IP) |
| Marketplace/Inception | **Vertivo** (GTM) | program application + partner process |

## 7. Risks

| Risk | Mitigation |
|---|---|
| Domain gap (synthetic ≠ real leaves) | hybrid mix; NuRec real backgrounds; aggressive DR |
| Isaac Sim compute (no A100/H100) | RTX workstation or build.nvidia.com sandbox; Inception HW credits |
| Over-engineering greenhouse control with PLC stacks | extend custom MQTT orchestrator; Modbus only at the edge |
| Actuator/safety layer is the real critical path | local interlocks + fail-safe; test dosing in sim/bench before chemicals |
| Marketplace gated by product maturity | Inception now; mature vision-core in parallel; confirm vertical with Andrei |

## References
- PDR: [`proposal.md`](./proposal.md) · Tasks: [`tasks.md`](./tasks.md)
- 4 research agents (Marketplace · greenhouse-twin/SDG · factory-twin · OSS-automation)
- CR Tech Week 2026 NVIDIA Inception LATAM deck (Andrei Golfeto)
- sim-to-real precedent: arXiv 2603.28670 (Isaac Sim → YOLO → Jetson Orin NX)
