# Step 06: Integrate Existing `vertivo_server` with Vertivochain

> **Type:** `Improvement`

> **Size:** `M`

> **Strategy:** `Solo`

> **Components:** `Backend`, `Database`

> **Impact:** `Critical Path`

> **Flags:** ---

> **Branch:** `feat/vertivo-server-appchain-integration`

> **Spec Source:** N/A (adapts existing TraceabilityEndpoint to write through gRPC gateway)

> **Status:** `Not Started`

> **Dependencies:** `Step 05 (gRPC Gateway running)`

> **Linear Project:** `Backend`

---

## HUMAN LAYER

### User Story

As the **existing TraceabilityEndpoint**, I want **to write crop traceability records to the Vertivochain appchain via the gRPC gateway** so that **the PostgreSQL hash-chain becomes a read cache while the blockchain is the source of truth, and marketplace buyers can verify produce provenance trustlessly**.

### Background / Why

The existing `traceability_endpoint.dart` already implements the business logic: `addRecord()`, `getChain()`, `verifyChain()`, `generateReport()`. It uses a SHA256 hash-chain in PostgreSQL. This step modifies it to ALSO write to the `vertivolatam_produce.cairo` contract via the gRPC gateway.

The pattern is **dual-write with PostgreSQL as cache**:
1. Write to Vertivochain via gRPC gateway (source of truth)
2. On success, write to PostgreSQL (read cache for fast queries)
3. If blockchain write fails, queue for retry (don't lose the record)

This is NOT a rewrite — it's an enhancement to the existing endpoint.

### Analogy

Like adding a notary to a contract signing process. The contract (data) still exists on paper (PostgreSQL), but now it's also notarized (blockchain) for independent verification.

### Known Pitfalls & Gotchas

- Dart gRPC client needed — `grpc` and `protobuf` packages in pubspec.yaml
- The gRPC gateway must be running before this integration works
- Dual-write latency: blockchain writes are slower than PostgreSQL — don't block the user
- Need async write pattern: write to PostgreSQL immediately, queue blockchain write
- The `recordHash` and `previousHash` fields in the existing model become supplementary to on-chain state
- `verifyChain()` should be updated to verify against blockchain (not just PostgreSQL hash-chain)

---

## AGENT LAYER

### Objective

Add gRPC client to `vertivo_server`, modify `TraceabilityEndpoint` to dual-write (PostgreSQL + Vertivochain), implement async blockchain write queue, and update `verifyChain()` to verify against on-chain state.

### Current State Audit

#### Already Exists

- `apps/vertivo_server/lib/src/traceability/traceability_endpoint.dart` — Complete (155 LOC, 6 methods)
- `apps/vertivo_server/lib/src/traceability/traceability_record.spy.yaml` — 17 fields
- `apps/vertivo_server/lib/src/traceability/compliance_report.spy.yaml` — Scoring model
- `apps/vertivo_server/lib/src/traceability/compliance_template.spy.yaml` — 20+ standards
- `apps/vertivo_server/pubspec.yaml` — Current deps: serverpod 3.4.1, crypto, mqtt_client

#### Needs Creation

- `apps/vertivo_server/lib/src/traceability/grpc_client.dart` — gRPC client wrapper for produce service
- `apps/vertivo_server/lib/src/traceability/blockchain_queue.dart` — Async write queue (PostgreSQL-backed)
- `apps/vertivo_server/lib/src/generated/proto/` — Generated Dart gRPC stubs from produce.proto

#### Needs Modification

- `apps/vertivo_server/pubspec.yaml` — Add `grpc`, `protobuf` dependencies
- `apps/vertivo_server/lib/src/traceability/traceability_endpoint.dart` — Dual-write in `addRecord()`, blockchain verify in `verifyChain()`
- `apps/vertivo_server/lib/server.dart` — Initialize gRPC client on startup
- `traceability_record.spy.yaml` — Add `blockchainTxHash` and `onChainVerified` fields

### Context Files

- `apps/vertivo_server/lib/src/traceability/traceability_endpoint.dart` — Current implementation to modify
- `apps/vertivo_server/lib/server.dart` — Server initialization (add gRPC client init)
- `apps/vertivo_server/pubspec.yaml` — Dependencies to add to
- `apps/vertivolatam_gateway/proto/produce.proto` — Proto file for stub generation (from Step 05)

### Acceptance Criteria

- [ ] `addRecord()` writes to both PostgreSQL AND Vertivochain (via gRPC)
- [ ] If blockchain write fails, record is queued for retry (not lost)
- [ ] `verifyChain()` can verify against on-chain state (optional, fallback to hash-chain)
- [ ] New field `blockchainTxHash` populated on TraceabilityRecord after successful on-chain write
- [ ] New field `onChainVerified` boolean flag
- [ ] `getChain()` continues to read from PostgreSQL (fast path)
- [ ] gRPC client handles connection failures gracefully (doesn't crash backend)
- [ ] Integration tests pass with gRPC gateway mocked

### Technical Constraints

- gRPC endpoint: `http://localhost:50051` (gateway from Step 05)
- Dart packages: `grpc: ^4.0.0`, `protobuf: ^3.0.0`
- Async write queue backed by PostgreSQL table (not in-memory, survives restart)
- Timeout for blockchain write: 10 seconds, then queue for retry
- Max retries: 5, exponential backoff (1s, 2s, 4s, 8s, 16s)

### Verification Commands

```bash
# Generate gRPC stubs
protoc --dart_out=grpc:apps/vertivo_server/lib/src/generated/proto/ \
  apps/vertivolatam_gateway/proto/produce.proto

# Build
cd apps/vertivo_server && dart compile exe bin/main.dart -o bin/server

# Test (with mocked gateway)
cd apps/vertivo_server && dart test test/integration/traceability_blockchain_test.dart

# E2E (requires gateway + appchain running)
make dev-backend-restart
# Then call addRecord and verify blockchainTxHash is populated
```

### Agent Strategy

**Mode:** `Solo`

**Approach:**
1. Read existing traceability_endpoint.dart thoroughly
2. Add gRPC dependencies to pubspec.yaml
3. Generate Dart stubs from produce.proto
4. Create grpc_client.dart wrapper
5. Create blockchain_queue.dart for async retry
6. Modify addRecord() for dual-write
7. Add blockchainTxHash + onChainVerified fields to spy.yaml
8. Run serverpod generate
9. Create migration
10. Test

**Estimated tokens:** ~150-200K

---

## Implementation Plan

### Step-by-Step Actions

1. **Add dependencies to pubspec.yaml**
   - **Tool:** Edit
   - **Target:** `apps/vertivo_server/pubspec.yaml`
   - Add: `grpc: ^4.0.0`, `protobuf: ^3.0.0`

2. **Generate Dart gRPC stubs from produce.proto**
   - **Tool:** Bash
   - **Target:** `apps/vertivo_server/lib/src/generated/proto/`

3. **Create gRPC client wrapper**
   - **Tool:** Write
   - **Target:** `apps/vertivo_server/lib/src/traceability/grpc_client.dart`

4. **Add blockchainTxHash + onChainVerified fields**
   - **Tool:** Edit
   - **Target:** `apps/vertivo_server/lib/src/traceability/traceability_record.spy.yaml`

5. **Run serverpod generate + migration**
   - **Tool:** Bash

6. **Modify addRecord() for dual-write**
   - **Tool:** Edit
   - **Target:** `apps/vertivo_server/lib/src/traceability/traceability_endpoint.dart`

7. **Create blockchain write queue**
   - **Tool:** Write
   - **Target:** `apps/vertivo_server/lib/src/traceability/blockchain_queue.dart`

8. **Initialize gRPC client in server.dart**
   - **Tool:** Edit
   - **Target:** `apps/vertivo_server/lib/server.dart`

---

## Parallelization Recommendation

**Recommended mechanism:** `None (Solo)`

**Reasoning:** Sequential modifications to a single endpoint. Each change builds on the previous one. No benefit from parallelization.

**Cost estimate:** ~1x (~150-200K tokens)

---

## Linear Issue Recommendation

**Title:** Connect vertivo_server TraceabilityEndpoint to Vertivochain via gRPC
**Project:** Backend
**Priority:** Medium
**Labels:** Improvement, M, Solo, Backend, Database, Critical Path
**Description:** Dual-write pattern: PostgreSQL (cache) + Vertivochain (source of truth). Adds gRPC client, async write queue with retry, blockchainTxHash field. Non-breaking — existing hash-chain continues as fallback.

---

## Files Touched Summary

| Action | Path | Lines Changed (est.) |
|--------|------|---------------------|
| Create | `apps/vertivo_server/lib/src/traceability/grpc_client.dart` | ~80 |
| Create | `apps/vertivo_server/lib/src/traceability/blockchain_queue.dart` | ~120 |
| Create | `apps/vertivo_server/lib/src/generated/proto/` (generated) | ~200 |
| Modify | `apps/vertivo_server/pubspec.yaml` | ~3 |
| Modify | `apps/vertivo_server/lib/src/traceability/traceability_endpoint.dart` | ~40 |
| Modify | `apps/vertivo_server/lib/src/traceability/traceability_record.spy.yaml` | ~3 |
| Modify | `apps/vertivo_server/lib/server.dart` | ~10 |
