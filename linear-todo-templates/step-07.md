# Step 07: EMQX Swarm Topology for Private/Public Chain Routing

> **Type:** `Feature`

> **Size:** `M`

> **Strategy:** `Explore`

> **Components:** `Infra`, `Backend`, `Security`

> **Impact:** ---

> **Flags:** ---

> **Branch:** `feat/emqx-chain-routing`

> **Spec Source:** N/A (derived from EMQX swarm concept + dual chain architecture)

> **Status:** `Not Started`

> **Dependencies:** `Step 04 (Manufacturing backend), Step 06 (Customer backend integrated)`

> **Linear Project:** `IoT + Blockchain`

---

## HUMAN LAYER

### User Story

As the **EMQX message broker**, I want **to route greenhouse swarm events to the correct chain (private manufacturing or public produce) based on topic namespace** so that **manufacturing plant sensors publish to the private chain and customer greenhouse sensors publish to the public chain, with proper access control**.

### Background / Why

EMQX currently uses the topic pattern `vertivo/{userId}/greenhouse/{ghId}/sensor/{type}` for ALL greenhouses. But with two chains:

- **Manufacturing plant greenhouses** (QA test rigs, calibration units) should route to the PRIVATE manufacturing chain — these are internal units being tested before shipping
- **Customer greenhouses** (deployed swarms) should route to the PUBLIC produce chain — these produce food for the marketplace

The EMQX "swarm" concept (multiple greenhouses per user, multiple users, federated clusters) means the broker must understand which namespace a greenhouse belongs to and route accordingly.

### Topic Namespace Design

```
# PRIVATE (manufacturing plant)
vertivo/mfg/{plantId}/unit/{serialNumber}/sensor/{type}
vertivo/mfg/{plantId}/unit/{serialNumber}/qa/{testId}
vertivo/mfg/{plantId}/station/{stationId}/status

# PUBLIC (customer greenhouses — existing pattern, preserved)
vertivo/{userId}/greenhouse/{ghId}/sensor/{type}
vertivo/{userId}/greenhouse/{ghId}/alert/{level}
vertivo/{userId}/greenhouse/{ghId}/command/{device}
```

### Known Pitfalls & Gotchas

- EMQX ACL rules must prevent customer devices from publishing to `mfg/` topics
- Manufacturing plant may use different sensors (pressure gauges, assembly line sensors) vs agricultural sensors
- EMQX rule engine can route messages to different backends based on topic prefix — use this instead of application-level routing
- Federation between manufacturing plant EMQX cluster and customer-facing EMQX cluster may be needed at scale (different geographic locations)
- Raspberry Pi orchestrator currently hardcodes topic prefix — needs configuration for mfg vs customer mode

---

## AGENT LAYER

### Objective

Configure EMQX topic namespaces, ACL rules, and rule engine routing to separate manufacturing and customer greenhouse traffic. Update the Raspberry Pi orchestrator to support manufacturing mode. Add EMQX rule engine rules that route `mfg/` topics to manufacturing backend and `vertivo/{userId}/` topics to customer backend.

### Current State Audit

#### Already Exists

- `k8s/base/mqtt/emqx-cluster.yaml` — EMQX 5.8.6 cluster (single cluster, no ACL)
- `docs/content/docs/iot/mqtt-topics.md` — Topic structure documentation
- `apps/raspberry/src/networking/` — MQTT client with topic publishing
- `apps/raspberry/src/config.py` — Configuration with MQTT endpoint/port

#### Needs Creation

- `k8s/base/mqtt/emqx-acl.yaml` — ACL rules ConfigMap
- `k8s/base/mqtt/emqx-rules.yaml` — Rule engine routing rules
- `apps/raspberry/src/networking/topic_config.py` — Topic namespace configuration (mfg vs customer)

#### Needs Modification

- `k8s/base/mqtt/emqx-cluster.yaml` — Add ACL plugin config, rule engine config
- `apps/raspberry/src/config.py` — Add `VERTIVO_DEPLOYMENT_MODE` (mfg | customer)
- `apps/raspberry/docker-compose.yml` — Add `VERTIVO_DEPLOYMENT_MODE` env var
- `docs/content/docs/iot/mqtt-topics.md` — Document dual namespace
- `Makefile` — Add `dev-mqtt-acl-deploy`, `dev-mqtt-rules-deploy`

### Acceptance Criteria

- [ ] Manufacturing topics (`vertivo/mfg/...`) route to manufacturing backend (port 8180)
- [ ] Customer topics (`vertivo/{userId}/greenhouse/...`) route to customer backend (port 8080)
- [ ] ACL prevents customer devices from publishing to `mfg/` namespace
- [ ] ACL prevents manufacturing devices from publishing to customer namespace
- [ ] Raspberry Pi orchestrator respects `VERTIVO_DEPLOYMENT_MODE` for topic prefix
- [ ] EMQX dashboard shows separate topic trees for mfg and customer
- [ ] Rule engine rules deployed via K8s ConfigMap (GitOps-compatible)
- [ ] Documentation updated with dual namespace

### Agent Strategy

**Mode:** `Explore`

**Investigation questions:**
1. Does EMQX 5.8.6 support rule engine routing based on topic prefix?
2. What's the ACL format for EMQX operator CRD?
3. Can rule engine rules be declared in K8s manifests or must be configured via API?
4. Should manufacturing and customer use the same EMQX cluster or separate clusters?

**Read-only phase:**
- EMQX 5.x documentation for rule engine and ACL
- Current `emqx-cluster.yaml` for existing configuration
- Raspberry Pi orchestrator networking code for topic patterns

**Decision point:** Once EMQX rule engine configuration method is confirmed (CRD vs API vs ConfigMap), move to implementation.

---

## Parallelization Recommendation

**Recommended mechanism:** `None (Solo)`

**Reasoning:** Sequential exploration + configuration. Single agent reads EMQX docs, designs ACL/routing, updates K8s manifests, modifies Pi config.

**Cost estimate:** ~1x (~100-200K tokens)

---

## Linear Issue Recommendation

**Title:** EMQX swarm topology — route mfg/customer traffic to separate chains
**Project:** IoT + Blockchain
**Priority:** Low (T3)
**Labels:** Feature, M, Explore, Infra, Backend, Security
**Description:** Dual EMQX topic namespace (mfg/ vs customer/) with ACL and rule engine routing to separate backends. Supports private manufacturing chain and public produce chain.

---

## Files Touched Summary

| Action | Path | Lines Changed (est.) |
|--------|------|---------------------|
| Create | `k8s/base/mqtt/emqx-acl.yaml` | ~40 |
| Create | `k8s/base/mqtt/emqx-rules.yaml` | ~60 |
| Create | `apps/raspberry/src/networking/topic_config.py` | ~30 |
| Modify | `k8s/base/mqtt/emqx-cluster.yaml` | ~20 |
| Modify | `apps/raspberry/src/config.py` | ~10 |
| Modify | `apps/raspberry/docker-compose.yml` | ~3 |
| Modify | `docs/content/docs/iot/mqtt-topics.md` | ~50 |
| Modify | `Makefile` | ~20 |
