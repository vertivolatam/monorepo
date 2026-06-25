# `/ready-to-review-mergeable` — Design (Vertivo port, bifrost)

**Date:** 2026-06-25
**Owner:** Andrés (andres@dojocoding.io)
**Status:** Approved (brainstorm) — pendiente implementación (writing-plans)
**Scope:** monorepo `vertivolatam/monorepo` — primer slash command del repo (`.claude/commands/`)

## Context

Adaptar a Vertivo el comando original `/ready-to-review-mergeable` de `dojocoding/dojo-os`
(`.claude/commands/ready-to-review-mergeable.md`): maneja issues Linear hasta un **PR
bot-aprobado y mergeable** cada uno, y no para hasta que todos estén verdes. El original usa
el GitHub App `dojo-code-reviewer`; Vertivo usa **bifrost-keeper** (la extracción open-source
de ese reviewer, `chimeranext/bifrost-keeper`, CLI `bifrost-review`). Acabamos de adoptar
**GitFlow** (base = `develop`) y de crear la épica **VRTV-102** + sub-issues **VRTV-103…109**;
este comando es el que abrirá/manejará esos PRs.

Decisión de alcance (brainstorm): **port fiel** — implement + loop de reviewer + Stop hook —
no un gate-only.

## Goals / Non-goals

- **Goal:** un slash command que, por cada issue VRTV, implemente (vía `make-no-mistakes:implement`),
  abra el PR Ready-for-Review contra `develop`, y **no termine** hasta que cada PR tenga un
  **APPROVE con Confidence ≥ umbral**, con higiene Linear y un Stop hook que lo enforce.
- **Non-goal:** reescribir `make-no-mistakes:implement` (se reusa). No tocar la identidad de bot
  de bifrost (follow-up del ROADMAP de bifrost-keeper). No automatizar push/PR/merge sin HITL.

## Decisiones clave (con rationale)

1. **Port fiel** de la forma del original; se cambia solo lo específico de Vertivo.
2. **Reviewer = CodeRabbit (primario) + bifrost (last-resort).** Vertivo ya tiene CodeRabbit; bifrost
   entra **solo cuando el primario está rate-limited / caído / sin veredicto** — justo el caso que
   originó bifrost (rate-limit de CodeRabbit). Evita quemar ~400k tokens NIM/review cuando no hace falta.
3. **Trigger de bifrost = CLI** `bifrost-review pr <n> --post` (determinístico, NIM key vía Infisical/env).
   No depende de wiring de GitHub Actions.
4. **Detección de la review de bifrost por marcador en el body** (header BifrostKeeper / línea
   `Confidence: X/5`), **no por login** — bifrost aún postea con el token del usuario (sin identidad
   de bot; ROADMAP). Distinto del original, que filtra por login `dojo-code-reviewer` en `.reviews[*]`.
5. **Linear hygiene vía API GraphQL de vertivolatam, NO vía MCP.** El Linear MCP de la sesión está
   autenticado a otro workspace (DojoOS/etc.) y no llega a VRTV. Usar la key de
   `~/.config/linear/credentials.toml` (línea `vertivolatam`, dueño lapc506) + GraphQL.
   Ver memoria `reference-linear-vertivolatam-api` (IDs de team/proyecto/estado/labels).
6. **Base = `develop`** (GitFlow recién adoptado), no `main`.
7. **Umbral default = 4.5** (`--confidence` lo relaja). Bifrost/CodeRabbit dan ~4.2–4.8 a PRs
   genuinamente mergeables; 5.0 iteraría en cosmética, 4.0 sería laxo → 4.5 es el balance.

## Componentes (unidades, cada una con un propósito claro)

### 1. Slash command — `.claude/commands/ready-to-review-mergeable.md`
- **Qué hace:** orquesta el pipeline por issue. Frontmatter `description` + `argument-hint:
  "<VRTV-XXXX [VRTV-YYYY ...]> [--confidence 4.5]"`.
- **Parse args:** issue IDs (`VRTV-\d+`), threshold (`--confidence X.X`, default 4.5; nunca subirlo
  por encima de lo pedido).
- **Pipeline:** invoca `make-no-mistakes:implement` con los IDs (worktree+branch por issue, HITL).
- **Depende de:** make-no-mistakes:implement, el helper Linear (#3), el reviewer-gate (#4), el state file (#5).

### 2. Higiene Linear (helper) — vía GraphQL API
- **On start (por issue):** `get_issue` (GraphQL) → si falta project/assignee/priority, set vía
  `issueUpdate`/`save_issue` (project ← parent o pillar; assignee ← `me`/lapc506; priority ← parent o Medium).
  Flip state → **In Progress**. **Verificar con read-back** (comparar el campo al target); fallos →
  lista "manual Linear flips pending".
- **On goal (por PR que alcanza umbral):** flip state → **In Review**. **Nunca Done** (HITL del PO).
- **Cómo:** un script `scripts/linear/vrtv.sh` (o inline en el comando) que lee la key sin imprimirla
  y hace las mutations. Reusa los IDs estables de la memoria de referencia.

### 3. Reviewer gate (primario → last-resort)
- **Exit por PR:** no-Draft **AND** tiene un APPROVE con **Confidence ≥ umbral**.
- **Primario:** el loop de `make-no-mistakes:implement` (CodeRabbit/Greptile/Graphite). Si CodeRabbit
  APRUEBA limpio → listo.
- **Last-resort bifrost:** si el primario está rate-limited/caído/sin veredicto tras su intento,
  correr `bifrost-review pr <n> --post`; tomar su `Confidence: X/5` como gate.
- **Detección:** parsear `gh pr view <n> --json reviews` y, para bifrost, identificar la review por
  marcador en el body (no por login) + state APPROVED + `Confidence ≥ umbral`.
- **Iteración:** si < umbral → leer findings, fix, push, re-review. No bajar la vara.

### 4. State file — `.claude/.implement-prs`
- Primera línea = umbral (una vez). Luego un PR# por línea. Es el estado del Stop hook.
- Gitignored.

### 5. Stop hook — `.claude/hooks/stop-prs-green.sh` + `.claude/settings.json`
- **Qué hace:** bloquea el fin de sesión mientras `.claude/.implement-prs` liste algún PR que sea
  draft, sin review, no-APPROVED, o < umbral. Portado del `stop-prs-green.sh` de dojo-os, **adaptado**
  a detectar la review de bifrost por marcador en el body (no por login).
- **Wiring:** entrada `Stop` en `.claude/settings.json` apuntando al script.

## Data flow

```
/ready-to-review-mergeable VRTV-105 [--confidence 4.5]
  │ parse IDs + threshold
  ▼
Linear(GraphQL): project/assignee/priority ✔ ; state → In Progress (verify)
  ▼
make-no-mistakes:implement VRTV-105  → worktree+branch → (HITL) PR Ready-for-Review → develop
  ▼
append PR# a .claude/.implement-prs (1ª línea = 4.5)
  ▼
Reviewer gate:  CodeRabbit (primario) ──aprueba≥4.5?── sí → ✔
                    │ no/rate-limited/sin-veredicto
                    ▼
                bifrost-review pr <n> --post  → Confidence X/5 ≥ 4.5 ? ── no → fix→push→re-review (loop)
  ▼ (≥ umbral)
Linear(GraphQL): state → In Review (verify; nunca Done)
  ▼
Stop hook: ¿todos los PR de .implement-prs verdes? ── no → bloquea fin de sesión
  ▼ sí
borrar .implement-prs + reporte (Issue → PR → Confidence → Linear state[applied|PENDING-MANUAL])
```

## Prerequisitos

- `bifrost-review` CLI disponible (`bun link` en `~/Documentos/GitHub/chimeranext/bifrost-keeper`).
- `bifrost-review install` en el monorepo → scaffoldea `/bifrost-local-review` + agrega `*.nvidia.env`
  al `.gitignore`. (El loop usa el CLI `pr`, pero `install` deja la base + hygiene de la NIM key.)
- NIM key disponible (Infisical o `.{staging|prod}.nvidia.env`); `GITHUB_TOKEN` para `--post`.
- Linear key de vertivolatam en `~/.config/linear/credentials.toml`.

## Error handling

- **NIM rate-limit (cuenta):** si bifrost también satura, reportar y NO marcar verde; dejar el PR en
  la lista pendiente. (No falsear APPROVE.)
- **Linear write no-op:** read-back siempre; fallos → "manual flips pending" en el reporte final.
- **bifrost sin veredicto parseable:** tratar como no-aprobado; iterar o escalar a HITL.
- **PR cross-cutting:** abrir como Draft (regla heredada), no taggear reviewer en Draft.

## Testing / verificación

- **Dry-run:** correr el comando con un issue trivial (VRTV de prueba) y `--confidence 4.0`; verificar:
  flip In Progress (read-back), PR abierto a `develop` Ready-for-Review, PR# en `.implement-prs`.
- **Gate:** forzar un finding (cambio con bug obvio) → confirmar que el loop NO marca verde hasta fix.
- **Last-resort:** simular CodeRabbit ausente → confirmar fallback a `bifrost-review pr`.
- **Stop hook:** con un PR no-verde en `.implement-prs`, intentar terminar la sesión → debe bloquear.
- **On success:** todos verdes → `.implement-prs` borrado + tabla de reporte correcta.

## Adaptaciones vs original dojo-os (resumen)

| Aspecto | dojo-os | Vertivo |
|---|---|---|
| Reviewer | `dojo-code-reviewer` (GitHub App) | CodeRabbit primario + **bifrost last-resort** (CLI `pr --post`) |
| Detección verdict | login en `.reviews[*]` | **marcador en el body** (sin bot identity) |
| Linear | MCP | **API GraphQL vertivolatam** (MCP en workspace equivocado) |
| Base PR | main | **develop** (GitFlow) |
| Umbral default | 5.0 | **4.5** |
| make-no-mistakes:implement | sí | sí (reusado) |
| Stop hook | `stop-prs-green.sh` | portado + adaptado a bifrost |
