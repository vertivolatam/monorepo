# Step 02: `vertivolatam_manufacturing.cairo` — Private Manufacturing Contract

> **Type:** `Feature`

> **Size:** `L`

> **Strategy:** `Team`

> **Components:** `Backend`, `Security`, `Database`

> **Impact:** `Critical Path`, `Revenue`

> **Flags:** ---

> **Branch:** `feat/vertivolatam-manufacturing-cairo`

> **Spec Source:** N/A (derived from Notion manufacturing pages + assetTracking state machine + ISO compliance)

> **Status:** `Not Started`

> **Dependencies:** `Step 01 (Vertivochain running)`

> **Linear Project:** `Blockchain`

---

## HUMAN LAYER

### User Story

As the **manufacturing plant manager**, I want **an immutable, verifiable record of every greenhouse unit's journey from component sourcing through assembly, QA, and delivery** so that **warranty claims, refurbishment cycles, and multi-country distributor verification are trustless and auditable**.

### Background / Why

Vertivo manufactures micro-greenhouses using Lean/Six Sigma processes (Toyota Production System: Jidoka, JIT, 5S, Kanban). The manufacturing chain must track each unit through: component sourcing (BOM) --> 3D printing (Gigabot industrial) --> welding/assembly --> Six Sigma QA inspection --> packaging --> shipping --> delivery --> warranty --> refurbishment.

Three business verticals share this chain with different ownership models:
1. **Farm Automation**: Ownership transfers to customer at delivery
2. **Product-as-a-Service**: Vertivo retains ownership, customer is custodian (leasing model, like assetTracking)
3. **Urban-Farming-as-a-Service**: Greenhouse never leaves Vertivo's control

This contract is **private** — only Vertivo employees and authorized distributors can write. External parties can verify a unit's provenance via its serial number but cannot see internal manufacturing details.

Compliance: ISO 9001:2015 (Quality), ISO 28000 (Supply Chain Security), ISO 59000 (Circular Economy for refurbishment), Lean manufacturing metrics.

### Analogy

This is the "birth certificate + medical record" for each greenhouse unit. Every event in its life is recorded immutably, from the moment components are sourced until the unit is decommissioned or refurbished.

### UX / Visual Reference

**State Machine:**
```
SOURCING --> PRINTING_3D --> ASSEMBLY --> QA_INSPECTION
    |                                        |
    |                                   [pass/fail]
    |                                    /        \
    |                              PACKAGED    REWORK
    |                                 |           |
    |                              SHIPPED    (back to ASSEMBLY)
    |                                 |
    |                             DELIVERED
    |                            /    |    \
    |                     IN_WARRANTY  |  LEASED (PaaS vertical)
    |                        |         |         |
    |                   REFURBISHING   |    LEASE_RETURNED
    |                        |         |         |
    |                   (back to QA)   |    QA_INSPECTION
    |                                  |
    |                           DECOMMISSIONED
```

### Known Pitfalls & Gotchas

- Cairo has no native string type — use felt252 for short strings or ByteArray for longer ones
- Private contracts on Starknet still have public state — "private" means restricted write access via access control, not encrypted state. For true privacy, consider Blockchain Data Availability layers or off-chain storage with on-chain hashes
- The 3 verticals (sell/lease/service) share the same contract but need different state transitions — use a `ownership_model` enum field
- ISO compliance checks should NOT be computed on-chain (too expensive) — store compliance score as a field, compute off-chain
- Scarb 2.12.2 and Starknet Foundry 0.49.0 needed (from keikolatam's quick-start.sh)
- Contract upgradeability: Use OpenZeppelin's upgradeable pattern (proxy + implementation) since manufacturing requirements WILL change

---

## AGENT LAYER

### Objective

Create the `vertivolatam_manufacturing.cairo` smart contract with a full state machine for greenhouse unit lifecycle, access control for private writes, and events for off-chain indexing. Include Scarb project structure, unit tests via `snforge`, and deployment scripts.

### Current State Audit

#### Already Exists

- Nothing. Zero Cairo code in the Vertivo monorepo.

#### Needs Creation

- `contracts/vertivolatam_manufacturing/Scarb.toml` — Scarb project config
- `contracts/vertivolatam_manufacturing/src/lib.cairo` — Module root
- `contracts/vertivolatam_manufacturing/src/manufacturing.cairo` — Main contract
- `contracts/vertivolatam_manufacturing/src/models.cairo` — Data structures (GreenhouseUnit, ManufacturingEvent, QAResult)
- `contracts/vertivolatam_manufacturing/src/access_control.cairo` — Role-based access (MANUFACTURER, QA_INSPECTOR, SHIPPING, DISTRIBUTOR)
- `contracts/vertivolatam_manufacturing/src/events.cairo` — Event definitions for off-chain indexing
- `contracts/vertivolatam_manufacturing/tests/test_manufacturing.cairo` — Unit tests
- `contracts/vertivolatam_manufacturing/scripts/deploy.sh` — Deployment to Vertivochain

#### Needs Modification

- `Makefile` — Add `dev-contracts-build`, `dev-contracts-test`, `dev-contracts-deploy-mfg`

### Context Files

- `/home/kvttvrsis/Documentos/GitHub/assetTracking/org1/contract/lib/assetcontract.js` — State machine reference (manufactureAsset, transferAsset, inspectAsset, repairAsset)
- `/home/kvttvrsis/Documentos/GitHub/assetTracking/org1/contract/lib/asset.js` — Asset model reference (states, conditions)
- `/home/kvttvrsis/Documentos/GitHub/keikolatam/dapp-monorepo/grpc-gateway/quick-start.sh` — Scarb/Foundry installation
- Notion: Manufactura Lean & Six Sigma (notion.so/7864da8bca7f4b47b76c882ca4f8a2bb)
- Notion: Estructura de Costos (notion.so/cc8ef253496c4a3c8167996257574157)
- Notion: Normalizacion ISO (notion.so/5a415f231d2d4f549a22d1d7ebd71beb)

### Acceptance Criteria

- [ ] Scarb project compiles without errors (`scarb build`)
- [ ] All state transitions enforce valid paths (e.g., can't go from SOURCING to SHIPPED)
- [ ] Access control restricts writes to authorized roles
- [ ] Events emitted for every state transition (for off-chain indexing)
- [ ] Unit tests cover: happy path (full lifecycle), invalid transitions, unauthorized access, all 3 ownership models
- [ ] `snforge test` passes all tests
- [ ] Contract deployable to Vertivochain devnet
- [ ] QA inspection records: inspector ID, DPMO metric, pass/fail, defect categories
- [ ] Refurbishment cycle works: REFURBISHING --> QA_INSPECTION --> PACKAGED (re-enters chain)

### Technical Constraints

- Cairo 2.x syntax (not Cairo 0.x)
- Use OpenZeppelin Cairo contracts for access control (`openzeppelin::access::ownable`)
- State stored as `LegacyMap<felt252, GreenhouseUnit>` keyed by serial number
- Events MUST include: `unit_serial`, `from_state`, `to_state`, `timestamp`, `actor`
- Compliance scores stored as u16 (0-10000, representing 0.00%-100.00%)
- All string-like fields use `ByteArray` for variable length

### Verification Commands

```bash
# Pre-flight
which scarb && scarb --version
which snforge && snforge --version

# Build
cd contracts/vertivolatam_manufacturing
scarb build

# Test
snforge test

# Deploy (requires Step 01 running)
make dev-contracts-deploy-mfg
```

### Agent Strategy

**Mode:** `Team`

**Lead role:** Coordinator — designs state machine, reviews both teammates' output.

**Teammates:**
- Teammate 1: **Contract Developer** --> owns `contracts/vertivolatam_manufacturing/src/*.cairo`
  - Implements state machine, storage, access control, events
- Teammate 2: **Test Engineer** --> owns `contracts/vertivolatam_manufacturing/tests/*.cairo`
  - Writes comprehensive snforge tests for all state transitions and edge cases

**Display mode:** `tab`
**Plan approval required:** yes (state machine design must be approved before coding)
**File ownership:** Explicit — Teammate 1 writes `src/`, Teammate 2 writes `tests/`

---

## Implementation Plan

### Pre-flight Checks

```bash
# Verify Scarb installed
scarb --version || echo "NEED: Install Scarb via asdf (see keikolatam quick-start.sh)"

# Verify Starknet Foundry
snforge --version || echo "NEED: Install via curl -L https://raw.githubusercontent.com/foundry-rs/starknet-foundry/master/scripts/install.sh | sh"

# Verify Vertivochain running (Step 01)
curl -s http://localhost:9945 || echo "NEED: Run 'make dev-appchain-deploy' first"
```

### Step-by-Step Actions

1. **Initialize Scarb project**
   - **Tool:** Bash
   - **Target:** `contracts/vertivolatam_manufacturing/`
   ```bash
   mkdir -p contracts/vertivolatam_manufacturing
   cd contracts/vertivolatam_manufacturing
   scarb init --name vertivolatam_manufacturing
   ```

2. **Define data models (models.cairo)**
   - **Tool:** Write
   - **Target:** `contracts/vertivolatam_manufacturing/src/models.cairo`
   ```cairo
   #[derive(Copy, Drop, Serde, starknet::Store)]
   enum UnitState {
       Sourcing,
       Printing3D,
       Assembly,
       QAInspection,
       Rework,
       Packaged,
       Shipped,
       Delivered,
       InWarranty,
       Leased,
       LeaseReturned,
       Refurbishing,
       Decommissioned,
   }

   #[derive(Copy, Drop, Serde, starknet::Store)]
   enum OwnershipModel {
       FarmAutomation,      // Sold to customer
       ProductAsAService,   // Leased, Vertivo retains ownership
       UrbanFarmingAAS,     // Vertivo operates internally
   }

   #[derive(Copy, Drop, Serde, starknet::Store)]
   enum UnitCondition {
       New,
       Refurbished,
       NeedsRepair,
   }

   #[derive(Copy, Drop, Serde, starknet::Store)]
   struct GreenhouseUnit {
       serial_number: felt252,
       model_type: felt252,
       ownership_model: OwnershipModel,
       current_state: UnitState,
       condition: UnitCondition,
       manufacturer: felt252,
       current_owner: felt252,
       current_custodian: felt252,
       qa_score: u16,          // 0-10000 (DPMO-derived)
       percent_damage: u16,    // 0-10000
       location: felt252,
       created_at: u64,
       updated_at: u64,
   }
   ```

3. **Implement main contract (manufacturing.cairo)**
   - **Tool:** Write
   - **Target:** `contracts/vertivolatam_manufacturing/src/manufacturing.cairo`
   - **Description:** State machine with transition functions: `source_components`, `start_printing`, `complete_assembly`, `inspect_qa`, `package_unit`, `ship_unit`, `deliver_unit`, `start_warranty`, `start_lease`, `return_lease`, `start_refurbishment`, `decommission`

4. **Implement access control (access_control.cairo)**
   - **Tool:** Write
   - **Target:** `contracts/vertivolatam_manufacturing/src/access_control.cairo`
   - **Description:** Roles: ADMIN, MANUFACTURER, QA_INSPECTOR, SHIPPING, DISTRIBUTOR, CUSTOMER

5. **Implement events (events.cairo)**
   - **Tool:** Write
   - **Target:** `contracts/vertivolatam_manufacturing/src/events.cairo`
   - **Description:** Events for state transitions, QA results, ownership transfers

6. **Write tests**
   - **Tool:** Write
   - **Target:** `contracts/vertivolatam_manufacturing/tests/test_manufacturing.cairo`

7. **Add Makefile targets**
   - **Tool:** Edit
   - **Target:** `Makefile`
   ```makefile
   dev-contracts-build:  ## Build all Cairo contracts
   	cd contracts/vertivolatam_manufacturing && scarb build

   dev-contracts-test:  ## Test all Cairo contracts
   	cd contracts/vertivolatam_manufacturing && snforge test

   dev-contracts-deploy-mfg:  ## Deploy manufacturing contract to Vertivochain
   	@echo "Deploying vertivolatam_manufacturing to Vertivochain..."
   	# starkli deploy ...
   ```

### Post-flight Verification

```bash
cd contracts/vertivolatam_manufacturing
scarb build
snforge test
# All tests should pass
```

---

## Parallelization Recommendation

**Recommended mechanism:** `Agent Teams (2 teammates)`

**Reasoning:** Contract code and test code are independent once the data model is agreed upon. Teammate 1 writes the contract, Teammate 2 writes tests against the interface. Both can work in parallel after the models.cairo is finalized.

**Cost estimate:** ~2x base token cost (~400-500K tokens)

---

## Linear Issue Recommendation

**Title:** Create vertivolatam_manufacturing.cairo — Private manufacturing traceability contract
**Project:** Blockchain
**Priority:** Medium
**Labels:** Feature, L, Team, Backend, Security, Critical Path, Revenue
**Description:** Cairo smart contract for greenhouse manufacturing chain of custody. State machine: SOURCING -> 3D_PRINTING -> ASSEMBLY -> QA -> SHIP -> DELIVER -> WARRANTY/LEASE -> REFURBISH. Supports 3 verticals (sale, lease, service). Private writes, public verification.

---

## Files Touched Summary

| Action | Path | Lines Changed (est.) |
|--------|------|---------------------|
| Create | `contracts/vertivolatam_manufacturing/Scarb.toml` | ~20 |
| Create | `contracts/vertivolatam_manufacturing/src/lib.cairo` | ~10 |
| Create | `contracts/vertivolatam_manufacturing/src/models.cairo` | ~120 |
| Create | `contracts/vertivolatam_manufacturing/src/manufacturing.cairo` | ~400 |
| Create | `contracts/vertivolatam_manufacturing/src/access_control.cairo` | ~80 |
| Create | `contracts/vertivolatam_manufacturing/src/events.cairo` | ~60 |
| Create | `contracts/vertivolatam_manufacturing/tests/test_manufacturing.cairo` | ~300 |
| Create | `contracts/vertivolatam_manufacturing/scripts/deploy.sh` | ~30 |
| Modify | `Makefile` | ~20 |

---

### Synthesis Additional Comments

#### MECE Logical Validation

**Mutually Exclusive:** The manufacturing contract handles ONLY hardware lifecycle. Crop produce is in a separate contract (Step 03). No overlap in state machines or storage.

**Collectively Exhaustive:** Covers all states from Notion manufacturing docs: sourcing (BOM), 3D printing (Gigabot), assembly (welding), QA (Six Sigma DPMO), shipping, delivery, warranty, leasing (PaaS), refurbishment (ISO 59000 circular economy), decommissioning. All 3 verticals supported via `OwnershipModel` enum.

#### Executive Synthesis (Minto Pyramid)

1. **Answer:** This contract creates the immutable manufacturing record that enables multi-country distributor verification and warranty automation for 5 LATAM markets.
2. **Supporting:** (a) State machine derived from assetTracking + Lean manufacturing processes, (b) Access control ensures privacy of internal manufacturing data, (c) Events enable off-chain indexing for fast queries.
3. **Evidence:** 13 states, 6 roles, 3 ownership models, ~1,000 LOC Cairo + tests.

#### Pareto 80/20

The core state machine (source -> assemble -> QA -> ship -> deliver) covers 80% of manufacturing traceability. The leasing cycle (PaaS vertical) and refurbishment loop add the remaining 20% but are critical for the circular economy model.

#### Second-Order Thinking

- **Scalability:** Contract storage grows linearly with units manufactured. At 1,000 units/year, negligible. At 100,000/year, may need storage optimization (archival)
- **Downstream:** The gRPC gateway (Step 05) must map every state transition to a Cairo function call. Changes here ripple to the gateway
- **Maintenance:** Cairo language is evolving rapidly — pin Scarb version. OpenZeppelin Cairo contracts may change APIs between releases
