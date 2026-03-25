# Step 03: `vertivolatam_produce.cairo` — Public Crop Produce Contract

> **Type:** `Feature`

> **Size:** `L`

> **Strategy:** `Team`

> **Components:** `Backend`, `Security`, `Database`

> **Impact:** `Critical Path`, `Revenue`

> **Flags:** ---

> **Branch:** `feat/vertivolatam-produce-cairo`

> **Spec Source:** N/A (derived from existing TraceabilityEndpoint hash-chain + ISO 22000 + HACCP + RTCA)

> **Status:** `Not Started`

> **Dependencies:** `Step 01 (Vertivochain running)`

> **Linear Project:** `Blockchain`

---

## HUMAN LAYER

### User Story

As a **marketplace buyer**, I want **to verify the complete farm-to-table journey of produce grown in a Vertivo greenhouse** so that **I can trust the food is pesticide-free, meets ISO 22000 food safety standards, and was grown in the specific greenhouse I'm buying from**.

As a **greenhouse owner selling on the Caja Vertivo marketplace**, I want **an immutable public record of my crop's lifecycle** so that **buyers pay a premium for verified pesticide-free produce and I build reputation over time**.

### Background / Why

This is the PUBLIC chain — any marketplace buyer can verify a batch's provenance by scanning a QR code. The existing `TraceabilityEndpoint` in Serverpod already implements a SHA256 hash-chain prototype with 18 event types (planting through sale) and compliance templates for 20+ standards (ISO 22000, HACCP, SENASA, ANVISA, GLOBAL_GAP, etc.). This contract takes that prototype on-chain.

The key difference from the manufacturing chain: this is multi-tenant. Each greenhouse owner writes their own crop events. The swarm architecture (EMQX topic: `vertivo/{userId}/greenhouse/{ghId}/sensor/{type}`) means sensor data from thousands of greenhouses flows in real-time. The contract stores attestations (hashes of batches), not raw sensor data.

Compliance: ISO 22000:2018 (Food Safety), HACCP plans, RTCA 67.01.31:06 (Central American food registration), BPM (Min. Salud Costa Rica), INTE/DN 12:2022.

### Analogy

This is a "food passport" — like a vaccine passport but for produce. Every batch gets a verifiable record from seed to sale. Buyers scan a QR and see the full journey, verified by the blockchain, not by Vertivo's promise.

### UX / Visual Reference

**State Machine:**
```
PLANTED --> GERMINATED --> TRANSPLANTED --> GROWING
                                             |
                                        [sensor data attestations]
                                             |
                                          HARVESTED
                                             |
                                        SAFETY_INSPECTED
                                           /       \
                                     [pass]        [fail]
                                       |              |
                                   PACKAGED      QUARANTINED
                                       |              |
                                   LISTED_ON_    DISPOSED
                                   MARKETPLACE
                                       |
                                     SOLD
```

**Cross-chain link:** Each batch references the `greenhouse_serial` from the manufacturing contract (Step 02), proving the produce came from a verified Vertivo greenhouse.

### Known Pitfalls & Gotchas

- Multi-tenant writes: Each greenhouse owner must be authorized to write ONLY their own greenhouse's batches
- Sensor data is TOO LARGE for on-chain storage — store Merkle root of daily sensor readings, keep raw data in PostgreSQL
- Compliance check computation is expensive — store result on-chain, compute off-chain (oracle pattern)
- The 20+ compliance standards in the existing `compliance_template.spy.yaml` need to be mapped to on-chain template IDs
- QR code generation is off-chain (Flutter/web) — contract only provides the data to verify
- Cross-chain reference to manufacturing contract needs careful key design (serial_number as felt252)

---

## AGENT LAYER

### Objective

Create the `vertivolatam_produce.cairo` smart contract with crop batch lifecycle, multi-tenant greenhouse authorization, sensor data attestation (Merkle roots), compliance verification results, cross-chain links to manufacturing contract, and public read access for marketplace verification. Include Scarb project, snforge tests, and deployment scripts.

### Current State Audit

#### Already Exists

- `apps/vertivo_server/lib/src/traceability/traceability_endpoint.dart` — Hash-chain prototype (addRecord, getChain, verifyChain, generateReport)
- `apps/vertivo_server/lib/src/traceability/traceability_record.spy.yaml` — 18 event types defined
- `apps/vertivo_server/lib/src/traceability/compliance_template.spy.yaml` — 20+ standards, regions, categories
- `apps/vertivo_server/lib/src/traceability/compliance_report.spy.yaml` — Scoring model (passed/failed checks)

#### Needs Creation

- `contracts/vertivolatam_produce/Scarb.toml` — Scarb project config
- `contracts/vertivolatam_produce/src/lib.cairo` — Module root
- `contracts/vertivolatam_produce/src/produce.cairo` — Main contract
- `contracts/vertivolatam_produce/src/models.cairo` — CropBatch, ProduceEvent, ComplianceResult, SensorAttestation
- `contracts/vertivolatam_produce/src/authorization.cairo` — Multi-tenant greenhouse authorization
- `contracts/vertivolatam_produce/src/events.cairo` — Public events for marketplace indexing
- `contracts/vertivolatam_produce/tests/test_produce.cairo` — Unit tests
- `contracts/vertivolatam_produce/scripts/deploy.sh` — Deployment

#### Needs Modification

- `Makefile` — Add `dev-contracts-deploy-produce`

### Context Files

- `apps/vertivo_server/lib/src/traceability/traceability_record.spy.yaml` — Event types to replicate
- `apps/vertivo_server/lib/src/traceability/traceability_endpoint.dart` — Business logic reference
- `apps/vertivo_server/lib/src/traceability/compliance_template.spy.yaml` — Standard codes
- `docs/content/docs/iot/mqtt-topics.md` — EMQX topic structure (swarm pattern)
- Notion: Auditoria Seguridad Alimentaria (notion.so/9dbf849d882541d3bc65b1c6daa62373)
- Notion: Normalizacion ISO - Alimentos section (notion.so/5a415f231d2d4f549a22d1d7ebd71beb)

### Acceptance Criteria

- [ ] Scarb project compiles (`scarb build`)
- [ ] Multi-tenant: Greenhouse owner A cannot write to greenhouse B's batches
- [ ] Cross-chain: Each batch stores `greenhouse_serial` (felt252 reference to manufacturing contract)
- [ ] Sensor attestation: Stores Merkle root of daily sensor readings (not raw data)
- [ ] Compliance: Stores on-chain result (standard_code, score, passed, timestamp, auditor)
- [ ] Public read: Anyone can query a batch by ID and get full event history
- [ ] All 10 states enforced (no invalid transitions)
- [ ] Events emitted for marketplace indexing (batch_created, state_changed, compliance_verified, batch_sold)
- [ ] `snforge test` passes all tests
- [ ] Deployable to Vertivochain devnet alongside manufacturing contract

### Technical Constraints

- Same Scarb/Foundry versions as Step 02
- Batch ID = `poseidon_hash(greenhouse_serial, crop_species, planting_timestamp)`
- Sensor attestation = `poseidon_hash(daily_readings_json)` computed off-chain
- Compliance template IDs use same codes as `compliance_template.spy.yaml` (ISO_22000, HACCP, etc.)
- Multi-tenant auth: Map `ContractAddress -> Vec<greenhouse_serial>` for write permissions
- Public reads: No access control on view functions

### Verification Commands

```bash
# Build
cd contracts/vertivolatam_produce
scarb build

# Test
snforge test

# Deploy (requires Step 01)
make dev-contracts-deploy-produce
```

### Agent Strategy

**Mode:** `Team`

**Lead role:** Coordinator — designs multi-tenant auth model and cross-chain linking.

**Teammates:**
- Teammate 1: **Contract Developer** --> owns `contracts/vertivolatam_produce/src/*.cairo`
- Teammate 2: **Test Engineer** --> owns `contracts/vertivolatam_produce/tests/*.cairo`

**Plan approval required:** yes (multi-tenant authorization model must be approved)

---

## Implementation Plan

### Step-by-Step Actions

1. **Initialize Scarb project** — `scarb init --name vertivolatam_produce`

2. **Define models** — CropBatch, ProduceEvent, SensorAttestation, ComplianceResult. Map existing 18 event types from traceability_record.spy.yaml to Cairo enums.

3. **Implement main contract** — State machine with: `create_batch`, `record_event`, `attest_sensor_data`, `inspect_safety`, `package_batch`, `list_on_marketplace`, `record_sale`, `quarantine`, `dispose`. Public views: `get_batch`, `get_batch_events`, `get_compliance`, `verify_batch`.

4. **Implement multi-tenant authorization** — `register_greenhouse(owner, greenhouse_serial)`, `authorize_operator(greenhouse_serial, operator)`. Write functions check `caller == owner || caller == operator`.

5. **Implement cross-chain link** — `greenhouse_serial` field on CropBatch links to manufacturing contract's GreenhouseUnit. Verification is off-chain (query both contracts by serial).

6. **Write tests** — Happy path, unauthorized write attempt, invalid transitions, compliance flow, cross-chain reference validation.

7. **Add Makefile target** — `dev-contracts-deploy-produce`

### Post-flight Verification

```bash
scarb build && snforge test
make dev-contracts-deploy-produce
```

---

## Parallelization Recommendation

**Recommended mechanism:** `Agent Teams (2 teammates)`
**Cost estimate:** ~2x (~400-500K tokens)

---

## Linear Issue Recommendation

**Title:** Create vertivolatam_produce.cairo — Public crop produce traceability contract
**Project:** Blockchain
**Priority:** Medium
**Labels:** Feature, L, Team, Backend, Security, Critical Path, Revenue
**Description:** Public Cairo contract for crop batch lifecycle on marketplace. Multi-tenant (each greenhouse owner writes their own). Sensor data attestation via Merkle roots. Compliance verification for ISO 22000/HACCP/RTCA. Cross-chain link to manufacturing contract.

---

## Files Touched Summary

| Action | Path | Lines Changed (est.) |
|--------|------|---------------------|
| Create | `contracts/vertivolatam_produce/Scarb.toml` | ~25 |
| Create | `contracts/vertivolatam_produce/src/lib.cairo` | ~10 |
| Create | `contracts/vertivolatam_produce/src/models.cairo` | ~150 |
| Create | `contracts/vertivolatam_produce/src/produce.cairo` | ~500 |
| Create | `contracts/vertivolatam_produce/src/authorization.cairo` | ~100 |
| Create | `contracts/vertivolatam_produce/src/events.cairo` | ~70 |
| Create | `contracts/vertivolatam_produce/tests/test_produce.cairo` | ~400 |
| Create | `contracts/vertivolatam_produce/scripts/deploy.sh` | ~30 |
| Modify | `Makefile` | ~10 |

---

### Synthesis Additional Comments

#### MECE Logical Validation

**Mutually Exclusive:** Produce contract handles ONLY crop lifecycle. Manufacturing handles ONLY hardware. They link via `greenhouse_serial` but never share storage or state transitions.

**Collectively Exhaustive:** All 18 event types from the existing spy.yaml are mapped. All 20+ compliance standards supported. Multi-tenant authorization covers swarm topology (many greenhouses, many owners). Sensor attestation covers real-time data without bloating on-chain storage.

#### Pareto 80/20

The core crop lifecycle (plant -> grow -> harvest -> inspect -> sell) covers 80% of marketplace value. Sensor attestation (Merkle roots of daily readings) adds verifiable data provenance with minimal on-chain cost. Compliance templates give the regulatory framework for 10 LATAM regions.

#### Second-Order Thinking

- **Scalability:** At 1,000 greenhouses x 10 batches/year = 10,000 batches/year. Each batch has ~10-15 events. ~150K on-chain writes/year — well within Starknet L3 capacity
- **Downstream:** Marketplace (Caja Vertivo) needs to read this contract to display verified badges. Flutter app needs QR scanner that queries the contract
- **Maintenance:** Adding new compliance standards (e.g., EU organic for export) requires only adding a new template ID — no contract upgrade needed. New event types DO require contract upgrade (use proxy pattern)
