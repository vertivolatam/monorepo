# Step 04: Manufacturing Backend (`vertivo_mfg_server`) — Second Serverpod App

> **Type:** `Feature`

> **Size:** `XL`

> **Strategy:** `Team`

> **Components:** `Backend`, `Database`, `Infra`

> **Impact:** `Critical Path`, `Revenue`

> **Flags:** `Epic` (needs decomposition)

> **Branch:** `feat/vertivo-mfg-server`

> **Spec Source:** N/A (derived from Notion manufacturing/costs/ISO pages + Lean Six Sigma)

> **Status:** `Not Started`

> **Dependencies:** `None (can start independently; blockchain integration comes in Step 05+06)`

> **Linear Project:** `Backend`

---

## HUMAN LAYER

### User Story

As the **manufacturing plant supervisor**, I want **a dedicated backend that manages the entire greenhouse production line — from component procurement through assembly, QA, shipping, and inventory** so that **manufacturing operations are tracked digitally with Lean/Six Sigma metrics, independent of the customer-facing platform**.

### Background / Why

The current `vertivo_server` is a **customer-facing platform** — it manages MQTT sensor data from customer greenhouse swarms, crop monitoring, alerts, and marketplace. Manufacturing a greenhouse is a completely different domain with different users (plant workers, QA inspectors, logistics, purchasing), different data (BOM, assembly stations, defect rates, shipping manifests), and different compliance requirements (ISO 9001 vs ISO 22000).

The user explicitly identified this: "se necesitan DOS backends: el actual define la plataforma que gestiona los datos MQTT que vienen del enjambre de invernaderos de los clientes, pero necesitamos OTRO para toda la planta de manufactura!"

From Notion's Estructura de Costos page, Vertivo has 3 manufacturing verticals:
1. **Farm Automation** — Manufacture + sell
2. **Product-as-a-Service** — Manufacture + lease
3. **Urban-Farming-as-a-Service** — Manufacture + operate internally

Each needs: procurement, assembly tracking, QA inspection, packaging, shipping, inventory management. The scaling guide (Notion) outlines phases: 10 units (MVP) -> 100 units (market test) -> 1,000 units (mass production).

### Analogy

This is like Toyota having separate systems for the factory floor (MES - Manufacturing Execution System) vs the dealership network (CRM/sales platform). The factory system tracks assembly, quality, and logistics; the dealership system tracks sales, service, and customer satisfaction. They share the VIN (serial number) as a link.

### Known Pitfalls & Gotchas

- XL scope — must decompose into sub-issues before implementation
- Serverpod workspace requires adding 2 new packages (`vertivo_mfg_server` + `vertivo_mfg_client`) to `pubspec.yaml`
- Separate PostgreSQL database needed (not sharing with customer-facing backend)
- Docker Compose needs updating for dev stack (separate postgres instance for manufacturing)
- K8s deployment needs its own manifests (separate from existing backend)
- Risk of scope creep: This is NOT a full ERP. It's traceability + QA + inventory. Accounting stays in external tools
- The COGS database already exists in Notion (collection://4626ea0a-...) — models should align with it

---

## AGENT LAYER

### Objective

Create a new Serverpod application (`vertivo_mfg_server`) in the monorepo with domain models for manufacturing operations, endpoints for plant workers and QA inspectors, Docker/K8s deployment, and Makefile targets. This backend operates independently of the customer-facing `vertivo_server` but shares the same monorepo infrastructure.

### Current State Audit

#### Already Exists

- `apps/vertivo_server/` — Customer-facing backend (reference for patterns)
- `apps/vertivo_server/Dockerfile` — Multi-stage Dart build (reference)
- `apps/vertivo_server/docker-compose.yaml` — Dev stack pattern (reference)
- `apps/vertivo_server/lib/server.dart` — Server initialization pattern (reference)
- `Makefile` — 73 targets with `dev-backend-*` convention for customer backend
- `k8s/base/backend/` — K8s manifests for customer backend (reference)
- `pubspec.yaml` — Dart workspace with 4 packages

#### Needs Creation

- `apps/vertivo_mfg_server/` — Full Serverpod app
  - `bin/main.dart`
  - `lib/server.dart`
  - `lib/src/` — Domain modules:
    - `procurement/` — BOM, suppliers, purchase orders
    - `assembly/` — Work orders, assembly stations, worker assignments
    - `quality/` — QA inspections, Six Sigma metrics (DPMO), defect tracking
    - `inventory/` — Finished goods, raw materials, WIP
    - `shipping/` — Shipping manifests, logistics, tracking
    - `units/` — Greenhouse unit registry (links to Cairo contract serial)
  - `pubspec.yaml`
  - `Dockerfile`
  - `docker-compose.yaml` (dev: postgres + redis on different ports)
  - `config/` (Serverpod config)
  - `migrations/` (DB migrations)
- `apps/vertivo_mfg_client/` — Generated client stubs
  - `pubspec.yaml`
- `k8s/base/mfg-backend/` — K8s manifests
- `k8s/overlays/dev/mfg-backend/` — Dev overlay

#### Needs Modification

- `pubspec.yaml` — Add `vertivo_mfg_server` + `vertivo_mfg_client` to workspace
- `Makefile` — Add `dev-mfg-*` targets (build, deploy, start, logs, generate, restart)
- `turbo.json` — Add build/test/generate tasks for mfg packages
- `k8s/argocd/applications/` — Add `mfg-backend-dev.yaml`
- `k8s/argocd/app-of-apps.yaml` — Add mfg-backend application
- `infrastructure/scripts/` — Add `build-mfg-image-minikube.sh`

### Context Files

- `apps/vertivo_server/pubspec.yaml` — Serverpod version (3.4.1) and dependency pattern
- `apps/vertivo_server/lib/server.dart` — Initialization pattern (auth, web routes)
- `apps/vertivo_server/Dockerfile` — Multi-stage Dart build pattern
- `apps/vertivo_server/docker-compose.yaml` — Dev stack pattern (postgres + redis)
- `apps/vertivo_server/lib/src/generated/endpoints.dart` — Endpoint registration pattern
- `k8s/base/backend/deployment.yaml` — K8s deployment pattern
- `infrastructure/scripts/build-backend-image-minikube.sh` — Image build script pattern
- Notion: Estructura de Costos (notion.so/cc8ef253496c4a3c8167996257574157) — COGS model
- Notion: Manufactura Lean & Six Sigma (notion.so/7864da8bca7f4b47b76c882ca4f8a2bb) — Process framework

### Acceptance Criteria

- [ ] `apps/vertivo_mfg_server/` compiles and starts locally (`make dev-mfg-start`)
- [ ] Separate PostgreSQL database (`vertivo_mfg`, port 8092 for dev)
- [ ] At minimum 6 endpoints: `unit`, `assembly`, `quality`, `inventory`, `shipping`, `procurement`
- [ ] At minimum 10 .spy.yaml models covering: GreenhouseBOM, Component, Supplier, WorkOrder, AssemblyStation, QAInspection, DefectReport, InventoryItem, ShipmentManifest, GreenhouseUnit
- [ ] `make dev-mfg-generate` produces protocol stubs
- [ ] `make dev-mfg-build` creates Docker image
- [ ] `make dev-mfg-deploy` deploys to minikube
- [ ] K8s deployment runs on port 8180 (not 8080, avoids conflict)
- [ ] `vertivo_mfg_client` package generates and other Dart packages can depend on it
- [ ] Unit tests pass

### Technical Constraints

- Serverpod version MUST match `vertivo_server` (3.4.1)
- Port assignments: API 8180, Insights 8181, Web 8182, PostgreSQL dev 8092, Redis dev 8093
- Makefile targets: `dev-mfg-verbo` (not `dev-backend-` — that's the customer backend)
- K8s namespace: same `vertivo-dev` (shared namespace, different deployments)
- Auth: Initially simple (API token for plant workers), NOT sharing auth with customer backend
- No MQTT dependency — manufacturing doesn't use sensor swarm data

### Agent Strategy

**Mode:** `Team`

**Lead role:** Coordinator — designs module boundaries, model schema, port assignments.

**Teammates:**
- Teammate 1: **Serverpod Architect** --> owns `apps/vertivo_mfg_server/lib/src/*.dart`, `pubspec.yaml`, `Dockerfile`
  - Creates app scaffold, models, endpoints, server.dart
- Teammate 2: **Infra Engineer** --> owns `k8s/base/mfg-backend/`, `Makefile` additions, `infrastructure/scripts/`
  - Creates K8s manifests, docker-compose, build scripts, Makefile targets
- Teammate 3: **QA/Models Specialist** --> owns `.spy.yaml` model files, test files
  - Designs data models aligned with Notion COGS database and Lean/Six Sigma metrics

**Plan approval required:** yes (model schema + port assignments must be approved)

---

## XL Decomposition

This step is XL-sized and should be decomposed into sub-issues:

### 04a: Scaffold (Size S)
- Create `apps/vertivo_mfg_server/` with minimal Serverpod app (greeting endpoint)
- Add to `pubspec.yaml` workspace
- Create `apps/vertivo_mfg_client/`
- Verify `serverpod generate` works

### 04b: Data Models (Size M)
- Define all .spy.yaml models (10+ models)
- Run `serverpod generate`
- Create initial migration

### 04c: Endpoints (Size M)
- Implement 6 endpoints with CRUD operations
- QA inspection workflow with Six Sigma metrics
- Assembly work order management

### 04d: Infrastructure (Size M)
- Dockerfile (copy pattern from vertivo_server)
- docker-compose.yaml (separate postgres + redis)
- K8s manifests (deployment, service, configmap)
- Makefile targets (8-10 new targets)
- ArgoCD application

### 04e: Testing (Size S)
- Integration tests for key endpoints
- Test database configuration

---

## Parallelization Recommendation

**Recommended mechanism:** `Agent Teams (3 teammates)`

**Reasoning:** Three independent workstreams: Serverpod app code, infrastructure/K8s, and data models/tests. All can proceed in parallel after the initial scaffold (04a) is done by the coordinator.

**Cost estimate:** ~3x base token cost (~600-800K tokens)

---

## Linear Issue Recommendation

**Title:** [Epic] Create manufacturing backend (vertivo_mfg_server)
**Project:** Backend
**Priority:** Medium
**Labels:** Feature, XL, Team, Backend, Database, Infra, Critical Path, Revenue, Epic
**Description:** Second Serverpod backend for manufacturing plant operations. Separate from customer-facing vertivo_server. Tracks BOM, assembly, QA (Six Sigma), inventory, shipping. Ports 818x to avoid conflicts. 5 sub-issues: scaffold, models, endpoints, infra, testing.

---

## Files Touched Summary

| Action | Path | Lines Changed (est.) |
|--------|------|---------------------|
| Create | `apps/vertivo_mfg_server/` (full app) | ~2,000 |
| Create | `apps/vertivo_mfg_client/pubspec.yaml` | ~30 |
| Create | `k8s/base/mfg-backend/` (4 manifests) | ~200 |
| Create | `k8s/overlays/dev/mfg-backend/` | ~30 |
| Create | `k8s/argocd/applications/mfg-backend-dev.yaml` | ~30 |
| Create | `infrastructure/scripts/build-mfg-image-minikube.sh` | ~40 |
| Modify | `pubspec.yaml` | ~4 |
| Modify | `Makefile` | ~80 |
| Modify | `turbo.json` | ~10 |
| Modify | `k8s/argocd/app-of-apps.yaml` | ~5 |

---

### Synthesis Additional Comments

#### MECE Logical Validation

**Mutually Exclusive:** Manufacturing backend handles ONLY plant operations (procurement, assembly, QA, shipping, inventory). Customer backend handles ONLY end-user operations (MQTT, monitoring, alerts, marketplace). They share `greenhouse_serial` as a cross-reference key but no database tables or endpoints.

**Collectively Exhaustive:** Covers the full manufacturing lifecycle from Notion: component sourcing (Estructura de Costos), assembly (Lean/5S workstations), QA (Six Sigma DPMO), packaging, shipping (transport costs databases), and inventory (Gestion Cuantitativa de Inventarios). Aligned with ISO 9001:2015 quality management.

#### Executive Synthesis (Minto Pyramid)

1. **Answer:** This creates the digital backbone for Vertivo's manufacturing plant, enabling Lean/Six Sigma tracking and multi-country distribution management.
2. **Supporting:** (a) Separate Serverpod app ensures manufacturing complexity doesn't bloat the customer platform, (b) Same tech stack (Dart/Serverpod) means shared knowledge and tooling, (c) K8s deployment follows existing patterns.
3. **Evidence:** 6 domain modules, 10+ models, 8 Makefile targets, separate PostgreSQL instance, Docker image, K8s manifests.

#### Pareto 80/20

Starting with `GreenhouseUnit` + `QAInspection` + `ShipmentManifest` (3 models, 3 endpoints) delivers 80% of traceability value. The full procurement/BOM/inventory system is the remaining 20% that becomes critical at the 1,000 unit production scale.

#### Second-Order Thinking

- **Scalability:** At scale, manufacturing backend may need its own MQTT broker for factory floor IoT (pick-to-light, barcode scanners). For now, HTTP REST is sufficient
- **Downstream:** The gRPC gateway (Step 05) bridges BOTH backends to the appchain. Manufacturing backend writes to `vertivolatam_manufacturing.cairo`, customer backend writes to `vertivolatam_produce.cairo`
- **Maintenance:** Two Serverpod backends means two `serverpod generate` cycles, two Docker images, two K8s deployments. The `Makefile` and `turbo.json` abstractions handle this, but developers need to be aware of which backend they're working on
