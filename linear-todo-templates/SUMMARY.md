# Vertivolatam Dual Chain-of-Custody: Implementation Summary

> **Epic:** Dual on-chain traceability for hardware manufacturing (private) + crop produce (public)
> **Appchain:** Madara/Starknet L3 ("Vertivochain") — adapted from keikolatam/dapp-monorepo
> **Date:** 2026-03-25
> **Status:** Architecture Phase (T2-T3 per SRD semver gate)

---

## Executive Summary

Vertivo requires two blockchain-backed chains of custody deployed as Cairo smart contracts on a private Starknet appchain. This epic introduces a **second Serverpod backend** for manufacturing plant operations (the current backend manages customer-facing MQTT swarm data). The manufacturing chain is private (internal QA/assembly); the crop produce chain is public (marketplace buyers verify food safety). EMQX topic architecture routes events to the appropriate chain based on greenhouse swarm topology.

---

## Architecture

```
                    PRIVATE                                 PUBLIC
            (Manufacturing Plant)                  (Customer Greenhouse Swarms)
                     |                                        |
        vertivo_mfg_server (NEW)              vertivo_server (EXISTING)
            Serverpod (Dart)                      Serverpod (Dart)
            PostgreSQL (cache)                    PostgreSQL (cache)
                     |                                        |
                     +------ gRPC Gateway (Rust) -------------+
                             (vertivolatam_gateway)
                                      |
                              Starknet RPC/WS
                                      |
                        Vertivochain (Madara Sequencer)
                    +-------------------+--------------------+
                    |                                        |
      vertivolatam_manufacturing.cairo     vertivolatam_produce.cairo
           (PRIVATE contract)                 (PUBLIC contract)
           ISO 9001, 28000, Lean              ISO 22000, HACCP, RTCA
                    |                                        |
                Settlement --> Starknet L2 --> Ethereum L1
```

---

## Dependency Graph

```
Step 01 (Vertivochain Appchain)     --> independent, do first
Step 02 (Manufacturing Cairo)       --> depends on 01
Step 03 (Produce Cairo)             --> depends on 01
Step 04 (Manufacturing Backend)     --> independent (Serverpod, no blockchain yet)
Step 05 (gRPC Gateway)              --> depends on 01 + 02 + 03
Step 06 (Integrate Existing Backend)--> depends on 05
Step 07 (EMQX Swarm Routing)        --> depends on 04 + 06
```

**Critical Path:** 01 --> 02+03 (parallel) --> 05 --> 06+04 (parallel) --> 07

**Parallelizable:**
- Steps 02 + 03 (two Cairo contracts, independent)
- Steps 04 + 06 (two backends, independent once gateway exists)

---

## Step Index

| Step | Title | Type | Size | Strategy | Status | SRD Tier |
|------|-------|------|------|----------|--------|----------|
| 01 | Vertivochain Appchain Infrastructure | Feature | L | Explore | Not Started | T2 |
| 02 | `vertivolatam_manufacturing.cairo` — Private Manufacturing Contract | Feature | L | Team | Not Started | T2 |
| 03 | `vertivolatam_produce.cairo` — Public Produce Contract | Feature | L | Team | Not Started | T2 |
| 04 | Manufacturing Backend (`vertivo_mfg_server`) | Feature | XL | Team | Not Started | T2 |
| 05 | gRPC Gateway (`vertivolatam_gateway`) | Feature | L | Team | Not Started | T2 |
| 06 | Integrate Existing Backend with Appchain | Improvement | M | Solo | Not Started | T2 |
| 07 | EMQX Swarm Topology for Private/Public Chain Routing | Feature | M | Explore | Not Started | T3 |

---

## Overall Progress

**Codebase Audit Results:**

| Component | Exists | % Complete | Notes |
|-----------|--------|-----------|-------|
| Appchain (Madara) | No | 0% | keikolatam pattern available for reference |
| Manufacturing Cairo contract | No | 0% | State machine needs design |
| Produce Cairo contract | No | 0% | Current PostgreSQL hash-chain = conceptual prototype |
| Manufacturing backend | No | 0% | No manufacturing models, endpoints, or workflows |
| gRPC Gateway | No | 0% | keikolatam gateway is also blueprint-only (no .rs files) |
| Existing backend integration | Partial | 15% | TraceabilityEndpoint exists with hash-chain (3 models, 1 endpoint) |
| EMQX swarm routing | Partial | 30% | Topic structure supports multi-greenhouse; no chain routing |

**Overall Epic:** ~5% complete (only the crop traceability hash-chain prototype exists)

---

## Recommended Execution Order

### Phase 0: Prerequisites (must complete before this epic)
- [ ] T0: Billing/latam_payments (VRTV-5) — Revenue = $0 without it
- [ ] T0: Flutter core screens consuming 13 endpoints (VRTV-6)
- [ ] T0: Greenhouse Configurator + Onboarding wizard (VRTV-7) — 5-step web wizard (top-of-funnel) + mobile onboarding (post-purchase), 10 unique screens sharing 3 steps, 6 new Serverpod endpoints. See `business-model/13-greenhouse-configurator.md`
- [ ] T1: Push notifications (VRTV-9)

**Note:** The Greenhouse Configurator serves dual purpose:
1. **Pre-sale (web):** vertivo.com/configurar → lead generation + pre-order with 50% deposit
2. **Post-sale (mobile):** device pairing QR → reuses Steps 1-3 → crop plan → first Caja order
Both share Flutter widgets and Serverpod endpoints. Build once, deploy twice.

### Phase 1: Foundation (Steps 01 + 04 in parallel)
- **Step 01**: Set up Vertivochain devnet (Madara) — adapted from keikolatam
- **Step 04**: Create manufacturing backend scaffold (vertivo_mfg_server)
  - Can start without blockchain — just Serverpod + PostgreSQL + manufacturing models

### Phase 2: Smart Contracts (Steps 02 + 03 in parallel)
- **Step 02**: `vertivolatam_manufacturing.cairo` (private)
- **Step 03**: `vertivolatam_produce.cairo` (public)
- Both require Scarb + Starknet Foundry installed (Step 01 prerequisite)

### Phase 3: Integration (Steps 05 + 06 sequential)
- **Step 05**: Build gRPC gateway (vertivolatam_gateway)
- **Step 06**: Wire existing vertivo_server to gateway

### Phase 4: Topology (Step 07)
- **Step 07**: EMQX swarm routing to private/public chains

---

## Total Estimated Effort

| Size | Count | Token Budget | Calendar Estimate |
|------|-------|-------------|-------------------|
| M | 2 | 200-400K | 2-4 days |
| L | 4 | 800K-2M | 12-20 days |
| XL | 1 | 500K+ | 3-5 days (decomposed) |
| **Total** | **7** | **~2M tokens** | **~4-6 weeks** |

---

## Linear Issues to Create

1. **[Epic] Vertivolatam Dual Chain-of-Custody** — Parent epic, T2 priority
2. **[Feature] Vertivochain Appchain Setup** — Infra & DevOps
3. **[Feature] vertivolatam_manufacturing.cairo** — Blockchain
4. **[Feature] vertivolatam_produce.cairo** — Blockchain
5. **[Feature] Manufacturing Backend (vertivo_mfg_server)** — Backend
6. **[Feature] vertivolatam_gateway (gRPC)** — Blockchain + Backend
7. **[Improvement] Connect vertivo_server to Vertivochain** — Backend
8. **[Feature] EMQX Swarm Chain Routing** — IoT + Blockchain

---

## Key Decisions Pending (Human Layer)

1. **Appchain branding**: `vertivochain` vs `vertivolatam-chain` vs other?
2. **Contract visibility**: How "public" is the produce chain? Public read, restricted write?
3. **Manufacturing backend scope**: Full ERP-lite or just traceability + QA?
4. **Lean/Six Sigma integration depth**: Digital Kanban boards? DPMO tracking? SMED timers?
5. **3D printing integration**: Track print jobs on-chain or just final QA result?
6. **Cross-chain references**: Does a greenhouse token in the mfg chain link to produce chain batches?
7. **Identity**: Reuse keikolatam's PoH pattern or simpler auth for manufacturing workers?

---

## Files Touched Summary (All Steps)

| Action | Path | Step |
|--------|------|------|
| Create | `apps/vertivochain/` (appchain dir) | 01 |
| Create | `apps/vertivochain/config/vertivochain.toml` | 01 |
| Create | `contracts/vertivolatam_manufacturing/` | 02 |
| Create | `contracts/vertivolatam_produce/` | 03 |
| Create | `apps/vertivo_mfg_server/` (full Serverpod app) | 04 |
| Create | `apps/vertivo_mfg_client/` (generated stubs) | 04 |
| Create | `apps/vertivolatam_gateway/` (Rust gRPC) | 05 |
| Modify | `apps/vertivo_server/lib/src/traceability/` | 06 |
| Modify | `k8s/base/` (new manifests for mfg backend + gateway + appchain) | 01,04,05 |
| Modify | `k8s/base/mqtt/emqx-cluster.yaml` (topic ACLs) | 07 |
| Modify | `Makefile` (~20 new targets) | 01,04,05 |
| Modify | `pubspec.yaml` (add mfg_server + mfg_client to workspace) | 04 |
| Modify | `pnpm-workspace.yaml` (if gateway uses Node tooling) | 05 |
| Modify | `turbo.json` (add build/test tasks for new apps) | 04,05 |
| Modify | `docs/content/docs/` (new sections for blockchain + manufacturing) | All |
