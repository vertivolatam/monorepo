# Step 01: Vertivochain Appchain Infrastructure

> **Type:** `Feature`

> **Size:** `L`

> **Strategy:** `Explore`

> **Components:** `Infra`, `Backend`, `Security`

> **Impact:** `Critical Path`

> **Flags:** ---

> **Branch:** `feat/vertivochain-appchain`

> **Spec Source:** N/A (derived from keikolatam/dapp-monorepo/appchain pattern)

> **Status:** `Not Started`

> **Dependencies:** `None`

> **Linear Project:** `Infrastructure & DevOps`

---

## HUMAN LAYER

### User Story

As a **platform architect**, I want **a dedicated Starknet L3 appchain (Vertivochain) running locally via Madara** so that **both traceability smart contracts can be deployed, tested, and iterated on without depending on external testnets**.

### Background / Why

Vertivo needs its own blockchain layer for two chain-of-custody systems: private (manufacturing) and public (crop produce). The keikolatam project already has a working Madara appchain setup (Keikochain) that can be adapted. This step creates the Vertivochain infrastructure: Madara sequencer, orchestrator, mock prover, and devnet scripts — all branded as "vertivolatam" and integrated into the existing Vertivo monorepo Makefile/Kustomize patterns.

The appchain runs as an L3 settling to Starknet L2, which settles to Ethereum L1. For dev, a mock prover and local Ethereum node are used. This is the foundation for Steps 02-07.

### Analogy

This is like building the factory floor before installing any machines. Without the appchain running, no smart contracts can be deployed or tested.

### UX / Visual Reference

```
Vertivochain (L3, Madara)
    |-- Sequencer (port 9944 P2P, 9945 RPC, 9946 WS)
    |-- Orchestrator (port 8080)
    |-- Mock Prover (port 8081)
    |-- Settlement --> Ethereum Local (port 8545)
```

### Known Pitfalls & Gotchas

- Madara CLI compilation requires Rust nightly + ~15min build time on first run
- Podman rootless mode (used by Vertivo's minikube) may conflict with Madara's container requirements
- keikolatam's quick-start.sh is 31KB and installs system-level deps — needs careful adaptation, not blind copy
- Port conflicts: Madara's 8080 (orchestrator) clashes with Serverpod's 8080 (API). Needs remapping
- WSL2 users need special Podman configuration (keikolatam has scripts for this)
- The keikochain.toml uses 2s block time — may need tuning for manufacturing chain throughput

---

## AGENT LAYER

### Objective

Create the Vertivochain appchain directory (`apps/vertivochain/`) with Madara configuration, devnet scripts, MCP server, and Makefile targets — adapted from keikolatam's appchain pattern with vertivolatam branding and port assignments that don't conflict with existing Vertivo services.

### Current State Audit

#### Already Exists

- `Makefile` — 73 targets with `env-recurso-verbo` convention (will add new targets)
- `k8s/base/` — Kustomize base with backend, database, mqtt resources
- `k8s/overlays/dev/` — Dev overlay structure
- `infrastructure/scripts/` — 4 bootstrap scripts (minikube, emqx, backend, raspberry)

#### Needs Creation

- `apps/vertivochain/config/vertivochain.toml` — Appchain configuration
- `apps/vertivochain/quick-start.sh` — Setup script (adapted from keikolatam)
- `apps/vertivochain/start-devnet.sh` — Start sequencer
- `apps/vertivochain/stop-devnet.sh` — Stop sequencer
- `apps/vertivochain/check-status.sh` — Health check
- `apps/vertivochain/README.md` — Documentation
- `apps/vertivochain/mcp-server/` — Starknet MCP server (adapted from keikolatam)
- `k8s/base/appchain/` — K8s manifests for containerized Madara (future)
- `infrastructure/scripts/setup-vertivochain.sh` — One-liner bootstrap

#### Needs Modification

- `Makefile` — Add `dev-appchain-*` targets (deploy, start, stop, status, logs)
- `pubspec.yaml` — No change (Rust/Cairo, not Dart)
- `pnpm-workspace.yaml` — Add `apps/vertivochain/mcp-server` if it uses Node
- `mcp.json` — Add starknet-reader MCP server entry
- `turbo.json` — No change (Madara is not a turbo task)

### Context Files

- `/home/kvttvrsis/Documentos/GitHub/keikolatam/dapp-monorepo/appchain/config/keikochain.toml` — Source config to adapt
- `/home/kvttvrsis/Documentos/GitHub/keikolatam/dapp-monorepo/appchain/quick-start.sh` — Source setup script
- `/home/kvttvrsis/Documentos/GitHub/keikolatam/dapp-monorepo/appchain/mcp-server/` — MCP server to adapt
- `/home/kvttvrsis/Documentos/GitHub/vertivolatam/monorepo/Makefile` — Naming convention reference
- `/home/kvttvrsis/Documentos/GitHub/vertivolatam/monorepo/k8s/base/backend/deployment.yaml` — K8s pattern reference
- `/home/kvttvrsis/Documentos/GitHub/vertivolatam/monorepo/mcp.json` — Existing MCP config

### Acceptance Criteria

- [ ] `apps/vertivochain/` directory exists with config, scripts, and MCP server
- [ ] `vertivochain.toml` uses ports that don't conflict with existing services (Serverpod 8080, PostgreSQL 5432, EMQX 1883/18083, Redis 6379)
- [ ] `make dev-appchain-deploy` starts Madara sequencer successfully
- [ ] `make dev-appchain-status` returns healthy
- [ ] `curl http://localhost:9945` returns Starknet RPC response
- [ ] MCP server configured in `mcp.json` and can query balances
- [ ] `make dev-appchain-destroy` cleans up all resources
- [ ] README documents all setup steps and port assignments

### Technical Constraints

- Makefile targets MUST follow `dev-appchain-verbo` convention
- Port assignments: Sequencer RPC 9945, WS 9946, P2P 9944, Orchestrator 9080 (not 8080!), Prover 9081
- Config file MUST say `name = "vertivochain"` (not keikochain)
- Scripts MUST use Podman (consistent with rest of Vertivo infra)
- MCP server MUST set `STARKNET_RPC_URL=http://127.0.0.1:9945`

### Verification Commands

```bash
# Pre-flight
which cargo && cargo --version
which podman && podman --version
ls /home/kvttvrsis/Documentos/GitHub/keikolatam/dapp-monorepo/appchain/config/keikochain.toml

# Deploy
cd /home/kvttvrsis/Documentos/GitHub/vertivolatam/monorepo
make dev-appchain-deploy

# Health check
curl -s http://localhost:9945 | head -c 200
make dev-appchain-status

# MCP verification
cat mcp.json | grep starknet

# Cleanup
make dev-appchain-destroy
```

### Agent Strategy

**Mode:** `Explore`

**Investigation questions:**
1. Can Madara CLI be installed via cargo without cloning the full repo?
2. What's the minimum Rust version needed? Does it conflict with anything in Vertivo?
3. Can the MCP server from keikolatam be used as-is or needs significant changes?
4. Should Madara run in a container (Podman) or as a native binary for dev?

**Read-only phase:**
- Full read of keikolatam's `appchain/quick-start.sh` (31KB)
- Full read of `appchain/madara-cli/Cargo.toml` for dependency chain
- Check Vertivo's Makefile for port assignments already in use
- Check `mcp.json` for existing MCP servers

**Decision point:** Once port mapping is confirmed and Madara installation method is chosen, move to implementation.

### Slack Notification

When done, send summary to user via Slack MCP with:
- Vertivochain devnet status (ports, health)
- Files created/modified
- Any port conflicts resolved

---

## Implementation Plan

### Pre-flight Checks

```bash
# Verify Rust is installed
rustc --version || echo "NEED: Install Rust via rustup"

# Verify Podman
podman --version || echo "NEED: Install Podman"

# Verify keikolatam reference exists
ls /home/kvttvrsis/Documentos/GitHub/keikolatam/dapp-monorepo/appchain/config/keikochain.toml

# Check port availability
ss -tlnp | grep -E '9944|9945|9946|9080|9081' || echo "Ports available"
```

### Step-by-Step Actions

1. **Create appchain directory structure**
   - **Tool:** Bash
   - **Target:** `apps/vertivochain/`
   - **Description:** Create directory tree
   ```bash
   mkdir -p apps/vertivochain/{config,mcp-server,scripts}
   ```

2. **Create vertivochain.toml**
   - **Tool:** Write
   - **Target:** `apps/vertivochain/config/vertivochain.toml`
   - **Description:** Adapted from keikochain.toml with vertivolatam branding and non-conflicting ports
   ```toml
   [appchain]
   name = "vertivochain"
   description = "Vertivolatam Starknet L3 Appchain — Dual traceability for manufacturing and agriculture"

   [sequencer]
   host = "127.0.0.1"
   port = 9944
   rpc_port = 9945
   ws_port = 9946

   [orchestrator]
   host = "127.0.0.1"
   port = 9080  # Avoids conflict with Serverpod 8080

   [prover]
   type = "mock"
   host = "127.0.0.1"
   port = 9081

   [settlement]
   type = "ethereum_local"
   host = "127.0.0.1"
   port = 8545

   [consensus]
   algorithm = "proof_of_stake"
   block_time = 2
   finality_threshold = 1

   [storage]
   type = "rocksdb"
   path = "./data"
   ```

3. **Adapt quick-start.sh from keikolatam**
   - **Tool:** Write
   - **Target:** `apps/vertivochain/quick-start.sh`
   - **Description:** Setup script that installs Madara CLI, configures Vertivochain, starts devnet

4. **Create start/stop/status scripts**
   - **Tool:** Write
   - **Target:** `apps/vertivochain/start-devnet.sh`, `stop-devnet.sh`, `check-status.sh`

5. **Adapt MCP server from keikolatam**
   - **Tool:** Write
   - **Target:** `apps/vertivochain/mcp-server/`
   - **Description:** Copy and rebrand keikolatam's MCP server, set RPC URL to 9945

6. **Add Makefile targets**
   - **Tool:** Edit
   - **Target:** `Makefile`
   - **Description:** Add dev-appchain-deploy, dev-appchain-start, dev-appchain-stop, dev-appchain-status, dev-appchain-logs, dev-appchain-destroy

7. **Update mcp.json**
   - **Tool:** Edit
   - **Target:** `mcp.json`
   - **Description:** Add starknet-reader entry pointing to vertivochain MCP server

8. **Create README**
   - **Tool:** Write
   - **Target:** `apps/vertivochain/README.md`

### Post-flight Verification

```bash
make dev-appchain-deploy
make dev-appchain-status
curl -s http://localhost:9945 | python3 -m json.tool
make dev-appchain-destroy
```

---

## Parallelization Recommendation

**Recommended mechanism:** `None (Solo)`

**Reasoning:** This is infrastructure setup — sequential by nature. One agent reads keikolatam's pattern, adapts it, creates files, and tests. No benefit from parallelization since each file depends on decisions made for the previous one (port assignments, naming).

**Cost estimate:** ~1x base token cost (~200-300K tokens)

---

## Linear Issue Recommendation

**Title:** Set up Vertivochain appchain (Madara/Starknet L3) for dual traceability
**Project:** Infrastructure & DevOps
**Priority:** Medium (blocked by T0/T1 prerequisites)
**Labels:** Feature, L, Explore, Infra, Security, Critical Path
**Description:** Create Vertivochain Madara devnet adapted from keikolatam pattern. Foundation for manufacturing (private) and produce (public) traceability contracts.

---

## Files Touched Summary

| Action | Path | Lines Changed (est.) |
|--------|------|---------------------|
| Create | `apps/vertivochain/config/vertivochain.toml` | ~30 |
| Create | `apps/vertivochain/quick-start.sh` | ~300 |
| Create | `apps/vertivochain/start-devnet.sh` | ~50 |
| Create | `apps/vertivochain/stop-devnet.sh` | ~30 |
| Create | `apps/vertivochain/check-status.sh` | ~40 |
| Create | `apps/vertivochain/README.md` | ~100 |
| Create | `apps/vertivochain/mcp-server/package.json` | ~20 |
| Create | `apps/vertivochain/mcp-server/src/index.ts` | ~150 |
| Modify | `Makefile` | ~60 |
| Modify | `mcp.json` | ~10 |

---

### Synthesis Additional Comments

#### MECE Logical Validation

**Mutually Exclusive:** Port 9080 chosen for orchestrator to avoid collision with Serverpod's 8080. Port 9081 for prover avoids Redis Commander (if ever used). All ports in the 99xx and 90xx range are unique to Vertivochain.

**Collectively Exhaustive:** Covers sequencer, orchestrator, prover, settlement, storage, MCP server, Makefile targets, and documentation. Missing: K8s manifests for containerized Madara (deferred — run native binary for dev, containerize for staging/prod later).

#### Executive Synthesis (Minto Pyramid)

1. **Answer:** This step creates the blockchain runtime that both traceability contracts will deploy to — without it, Steps 02-07 are blocked.
2. **Supporting:** (a) Madara config adapted from proven keikolatam pattern, (b) MCP server enables Claude Code to query chain state, (c) Makefile targets integrate with existing dev workflow.
3. **Evidence:** 5 scripts, 1 config, 1 MCP server, 6 Makefile targets, ~800 LOC total.

#### Pareto 80/20

Running Madara as a native binary (not containerized) for dev gives 80% of the value with 20% of the infra complexity. K8s manifests for Madara can be deferred to staging/prod.

#### Second-Order Thinking

- **Scalability:** Madara supports multi-node consensus — single node is fine for dev, but prod needs 3+ validators
- **Downstream:** ALL other steps depend on this. If ports change, Steps 02-07 config must update
- **Maintenance:** Madara CLI is a Rust binary that compiles from source — needs periodic updates. Pin to a specific commit/tag
