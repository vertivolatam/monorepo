# Step 05: gRPC Gateway (`vertivolatam_gateway`) — Rust ↔ Cairo Translator

> **Type:** `Feature`

> **Size:** `L`

> **Strategy:** `Team`

> **Components:** `Backend`, `Infra`, `Security`

> **Impact:** `Critical Path`

> **Flags:** ---

> **Branch:** `feat/vertivolatam-gateway`

> **Spec Source:** N/A (derived from keikolatam/dapp-monorepo/grpc-gateway pattern)

> **Status:** `Not Started`

> **Dependencies:** `Step 01 (Vertivochain running), Step 02 (manufacturing.cairo deployed), Step 03 (produce.cairo deployed)`

> **Linear Project:** `Blockchain + Backend`

---

## HUMAN LAYER

### User Story

As **both Serverpod backends**, I want **a gRPC gateway that translates my Dart RPC calls into Starknet transactions** so that **manufacturing events and crop traceability records are written to the Vertivochain appchain without either backend needing to understand Cairo or Starknet internals**.

### Background / Why

The two Serverpod backends (customer-facing + manufacturing) are written in Dart. The smart contracts are in Cairo on Starknet. These are incompatible worlds. The gRPC gateway acts as a translator:

```
Serverpod (Dart) --gRPC--> vertivolatam_gateway (Rust) --Starknet RPC--> Vertivochain (Cairo)
```

Keikolatam's `dapp-monorepo/grpc-gateway/` provides the architectural blueprint, but its implementation is also incomplete (README + quick-start only, no .rs source files). This step builds the actual gateway from the blueprint.

The gateway handles:
1. **Type conversion**: Dart types --> felt252/Cairo types
2. **Transaction signing**: Signs transactions with authorized account keys
3. **Event listening**: Subscribes to Vertivochain events, publishes to Redis Streams
4. **Health monitoring**: Reports appchain connectivity status

### Analogy

This is like an embassy translator. The Dart backends "speak Spanish" and the Cairo contracts "speak Japanese." The gateway translates in both directions, ensuring nothing is lost in translation.

### Known Pitfalls & Gotchas

- Dart doesn't have a native gRPC client for Starknet — this is WHY the Rust gateway exists
- The gateway needs Starknet account keys for signing transactions — secrets management is critical
- keikolatam's gateway is also unimplemented — we're building from blueprint, not copying working code
- Transaction failures need retry logic with exponential backoff (Starknet can reject transactions)
- Event subscription via WebSocket to Vertivochain may drop connections — needs reconnection logic
- Proto definitions must cover BOTH contracts (manufacturing + produce) — two service definitions
- The Rust toolchain adds a build dependency the Dart-only team may not be familiar with

---

## AGENT LAYER

### Objective

Create a Rust gRPC server (`vertivolatam_gateway`) that exposes two gRPC services — one for each Cairo contract — translating Serverpod calls to Starknet transactions and broadcasting events via Redis Streams. Include proto definitions, Cargo project, Docker image, K8s deployment, and Makefile targets.

### Current State Audit

#### Already Exists

- Nothing in Vertivo monorepo (0 Rust code, 0 .proto files, 0 gRPC)
- keikolatam blueprint: `grpc-gateway/README.md` (architecture) + `quick-start.sh` (Scarb/Foundry install)
- keikolatam planned structure: server/, translator/, client/, config/

#### Needs Creation

- `apps/vertivolatam_gateway/Cargo.toml` — Rust project
- `apps/vertivolatam_gateway/build.rs` — Proto compilation
- `apps/vertivolatam_gateway/proto/manufacturing.proto` — Manufacturing gRPC service
- `apps/vertivolatam_gateway/proto/produce.proto` — Produce gRPC service
- `apps/vertivolatam_gateway/src/main.rs` — Server entrypoint
- `apps/vertivolatam_gateway/src/manufacturing_service.rs` — Manufacturing gRPC handler
- `apps/vertivolatam_gateway/src/produce_service.rs` — Produce gRPC handler
- `apps/vertivolatam_gateway/src/starknet_client.rs` — Starknet RPC wrapper
- `apps/vertivolatam_gateway/src/events.rs` — Event listener + Redis publisher
- `apps/vertivolatam_gateway/src/config.rs` — Configuration
- `apps/vertivolatam_gateway/Dockerfile` — Multi-stage Rust build
- `k8s/base/gateway/` — K8s manifests
- `k8s/overlays/dev/gateway/` — Dev overlay

#### Needs Modification

- `Makefile` — Add `dev-gateway-*` targets
- `k8s/argocd/applications/` — Add `gateway-dev.yaml`
- `k8s/argocd/app-of-apps.yaml` — Include gateway
- `pnpm-workspace.yaml` — Not applicable (Rust, not Node)

### Context Files

- `/home/kvttvrsis/Documentos/GitHub/keikolatam/dapp-monorepo/grpc-gateway/README.md` — Architecture blueprint
- `/home/kvttvrsis/Documentos/GitHub/keikolatam/dapp-monorepo/grpc-gateway/quick-start.sh` — Toolchain setup
- `/home/kvttvrsis/Documentos/GitHub/keikolatam/dapp-monorepo/backend/modules/learning_passport/Cargo.toml` — starknet-rs dependency reference
- `/home/kvttvrsis/Documentos/GitHub/keikolatam/dapp-monorepo/.env.example` — gRPC port assignments (50051-50055)
- `contracts/vertivolatam_manufacturing/src/manufacturing.cairo` — ABI for manufacturing contract (from Step 02)
- `contracts/vertivolatam_produce/src/produce.cairo` — ABI for produce contract (from Step 03)
- `apps/vertivo_server/docker-compose.yaml` — Redis instance at port 8091 (reuse or add separate)

### Acceptance Criteria

- [ ] `cargo build` compiles without errors
- [ ] Proto files generate Rust server/client code via `tonic-build`
- [ ] Manufacturing gRPC service: `SourceComponents`, `StartPrinting`, `CompleteAssembly`, `InspectQA`, `PackageUnit`, `ShipUnit`, `DeliverUnit`, `StartWarranty`, `StartLease`, `ReturnLease`, `StartRefurbishment`, `Decommission`
- [ ] Produce gRPC service: `CreateBatch`, `RecordEvent`, `AttestSensorData`, `InspectSafety`, `PackageBatch`, `ListOnMarketplace`, `RecordSale`, `Quarantine`, `Dispose`
- [ ] Read methods: `GetUnit`, `GetBatch`, `GetBatchEvents`, `VerifyBatch`, `GetCompliance`
- [ ] Each write method submits a Starknet transaction and returns tx hash
- [ ] Events from Vertivochain are published to Redis Streams
- [ ] Dockerfile builds multi-stage (Rust build --> Alpine runtime)
- [ ] K8s deployment runs on port 50051 (gRPC)
- [ ] `make dev-gateway-deploy` deploys to minikube
- [ ] Health endpoint at `/health` returns appchain connectivity status

### Technical Constraints

- Rust dependencies: `tonic` (gRPC), `prost` (proto), `starknet-rs` (Starknet client), `redis` (event publishing), `tokio` (async runtime)
- Port: 50051 (gRPC), 50052 (health/metrics HTTP)
- Starknet RPC URL: `http://127.0.0.1:9945` (Vertivochain from Step 01)
- Account keys stored as K8s Secret (dev: env var, prod: KMS)
- Makefile targets: `dev-gateway-verbo` convention
- Docker image: Multi-stage — `rust:1.78-slim` build, `debian:bookworm-slim` runtime

### Verification Commands

```bash
# Pre-flight
cargo --version
protoc --version

# Build
cd apps/vertivolatam_gateway
cargo build

# Test
cargo test

# Deploy
make dev-gateway-build
make dev-gateway-deploy

# Health check
curl http://localhost:50052/health

# gRPC test (requires grpcurl)
grpcurl -plaintext localhost:50051 list
grpcurl -plaintext localhost:50051 vertivolatam.manufacturing.ManufacturingService/GetUnit
```

### Agent Strategy

**Mode:** `Team`

**Lead role:** Coordinator — designs proto service definitions, reviews type mappings.

**Teammates:**
- Teammate 1: **Rust/gRPC Developer** --> owns `src/*.rs`, `Cargo.toml`, `build.rs`
- Teammate 2: **Proto/Integration** --> owns `proto/*.proto`, tests, deployment scripts
- Teammate 3: **Infra** --> owns `Dockerfile`, `k8s/base/gateway/`, Makefile targets

**Plan approval required:** yes (proto service definitions must be approved)

---

## Implementation Plan

### Pre-flight Checks

```bash
cargo --version || echo "NEED: rustup install"
protoc --version || echo "NEED: apt install protobuf-compiler"
curl -s http://localhost:9945 || echo "NEED: Step 01 (Vertivochain)"
```

### Step-by-Step Actions

1. **Create Cargo project**
   ```bash
   mkdir -p apps/vertivolatam_gateway
   cd apps/vertivolatam_gateway
   cargo init --name vertivolatam_gateway
   ```

2. **Define proto: manufacturing.proto**
   ```protobuf
   syntax = "proto3";
   package vertivolatam.manufacturing;

   service ManufacturingService {
     rpc SourceComponents(SourceRequest) returns (TxResponse);
     rpc CompleteAssembly(AssemblyRequest) returns (TxResponse);
     rpc InspectQA(QARequest) returns (TxResponse);
     rpc ShipUnit(ShipRequest) returns (TxResponse);
     rpc DeliverUnit(DeliverRequest) returns (TxResponse);
     rpc GetUnit(UnitQuery) returns (GreenhouseUnit);
     // ... all state transitions
   }
   ```

3. **Define proto: produce.proto**
   ```protobuf
   syntax = "proto3";
   package vertivolatam.produce;

   service ProduceService {
     rpc CreateBatch(CreateBatchRequest) returns (TxResponse);
     rpc RecordEvent(EventRequest) returns (TxResponse);
     rpc AttestSensorData(AttestationRequest) returns (TxResponse);
     rpc GetBatch(BatchQuery) returns (CropBatch);
     rpc VerifyBatch(BatchQuery) returns (VerificationResult);
     // ... all state transitions
   }
   ```

4. **Implement Starknet client wrapper** — Connects to Vertivochain RPC, submits transactions, reads state

5. **Implement manufacturing service** — Maps each gRPC call to a Cairo function invocation

6. **Implement produce service** — Maps each gRPC call to a Cairo function invocation

7. **Implement event listener** — WebSocket subscription to Vertivochain, publishes to Redis Streams

8. **Create Dockerfile** — Multi-stage Rust build

9. **Create K8s manifests** — Deployment, Service, ConfigMap

10. **Add Makefile targets** — `dev-gateway-build`, `dev-gateway-deploy`, `dev-gateway-logs`, `dev-gateway-destroy`

### Post-flight Verification

```bash
make dev-gateway-build && make dev-gateway-deploy
curl http://localhost:50052/health
grpcurl -plaintext localhost:50051 list
```

---

## Parallelization Recommendation

**Recommended mechanism:** `Agent Teams (3 teammates)`
**Cost estimate:** ~3x (~500-700K tokens)

---

## Linear Issue Recommendation

**Title:** Create vertivolatam_gateway — gRPC bridge between Serverpod backends and Vertivochain
**Project:** Blockchain + Backend
**Priority:** Medium
**Labels:** Feature, L, Team, Backend, Infra, Security, Critical Path
**Description:** Rust gRPC server translating Dart backend calls to Starknet transactions. Two service definitions (manufacturing + produce). Event listener publishes to Redis Streams. Multi-stage Docker build.

---

## Files Touched Summary

| Action | Path | Lines Changed (est.) |
|--------|------|---------------------|
| Create | `apps/vertivolatam_gateway/Cargo.toml` | ~40 |
| Create | `apps/vertivolatam_gateway/build.rs` | ~15 |
| Create | `apps/vertivolatam_gateway/proto/manufacturing.proto` | ~120 |
| Create | `apps/vertivolatam_gateway/proto/produce.proto` | ~120 |
| Create | `apps/vertivolatam_gateway/src/main.rs` | ~80 |
| Create | `apps/vertivolatam_gateway/src/manufacturing_service.rs` | ~300 |
| Create | `apps/vertivolatam_gateway/src/produce_service.rs` | ~350 |
| Create | `apps/vertivolatam_gateway/src/starknet_client.rs` | ~200 |
| Create | `apps/vertivolatam_gateway/src/events.rs` | ~150 |
| Create | `apps/vertivolatam_gateway/src/config.rs` | ~50 |
| Create | `apps/vertivolatam_gateway/Dockerfile` | ~30 |
| Create | `k8s/base/gateway/` (4 manifests) | ~150 |
| Modify | `Makefile` | ~60 |
| Modify | `k8s/argocd/app-of-apps.yaml` | ~5 |

---

### Synthesis Additional Comments

#### MECE Logical Validation

**Mutually Exclusive:** Two proto service definitions — manufacturing and produce — map 1:1 to two Cairo contracts. No overlap in RPC methods or state management.

**Collectively Exhaustive:** Every Cairo contract function (all state transitions + read methods) has a corresponding gRPC method. Events from both contracts are captured and published to Redis.

#### Executive Synthesis (Minto Pyramid)

1. **Answer:** The gateway is the linchpin connecting Vertivo's Dart ecosystem to the Starknet blockchain — without it, no backend can write to or read from the appchain.
2. **Supporting:** (a) gRPC is language-agnostic — Dart gRPC client libraries exist, (b) Rust provides Starknet-native tooling (starknet-rs), (c) Event-driven architecture via Redis enables real-time UI updates.
3. **Evidence:** 2 proto files, ~1,500 LOC Rust, Docker image, K8s deployment, 6 Makefile targets.

#### Pareto 80/20

Implementing write methods (state transitions) gives 80% of value. Read methods can initially be served directly from PostgreSQL cache (existing traceability endpoint pattern). Event listener is the 20% that enables real-time — can be added after writes work.

#### Second-Order Thinking

- **Scalability:** gRPC supports streaming — future enhancement for batch operations (bulk QA reports, sensor attestation batches)
- **Downstream:** Both Serverpod backends depend on this gateway. Dart gRPC client stubs generated from the same proto files ensure type safety
- **Maintenance:** Rust binary needs separate CI/CD pipeline. Consider adding to GitHub Actions alongside the Dart workflows. Proto files are the contract between Dart and Rust — changes require coordinated updates
