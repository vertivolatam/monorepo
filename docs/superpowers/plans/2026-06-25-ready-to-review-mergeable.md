# `/ready-to-review-mergeable` Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Portar a `vertivolatam/monorepo` el slash command `/ready-to-review-mergeable` de dojo-os, adaptado a bifrost (last-resort) + CodeRabbit (primario), Linear vía API GraphQL de vertivolatam, base `develop`, umbral 4.5, con Stop hook que enforce PRs verdes.

**Architecture:** Un slash command (`.claude/commands/ready-to-review-mergeable.md`) orquesta `make-no-mistakes:implement` por issue, abre PR Ready-for-Review → `develop`, y registra cada PR en `.claude/.implement-prs`. Un Stop hook (`stop-prs-green.sh`) bloquea el fin de sesión hasta que cada PR tenga un APPROVE con `Confidence ≥ umbral` (marcador de bifrost en el body). La higiene Linear usa un helper bash que pega a la GraphQL API de vertivolatam (el MCP está en otro workspace).

**Tech Stack:** Markdown (slash command), Bash + `jq` + `gh` (hook, helper), `curl` (Linear GraphQL), `bifrost-review` CLI (bun, en `chimeranext/bifrost-keeper`).

**Spec:** `docs/superpowers/specs/2026-06-25-ready-to-review-mergeable-design.md`

---

## File Structure

- Create: `.claude/commands/ready-to-review-mergeable.md` — el comando (prompt).
- Create: `.claude/hooks/stop-prs-green.sh` — Stop hook (enforcement).
- Create: `.claude/hooks/pre-linear-save-issue-hygiene.sh` — PreToolUse guard sobre `save_issue` del Linear MCP (bloquea CREATEs sin triage completo).
- Create: `scripts/linear/vrtv.sh` — helper Linear GraphQL (get / ensure-fields / set-state + read-back).
- Create: `tests/hooks/test-stop-prs-green.sh` — tests deterministas del hook (sin red).
- Modify: `.claude/settings.json` — wiring del Stop hook (crear si no existe).
- Modify: `.gitignore` — `.claude/.implement-prs` + `*.nvidia.env`.
- Runtime (no se commitea): `.claude/.implement-prs` (state file), `.claude/commands/bifrost-local-review.md` (lo scaffoldea `bifrost-review install`).

---

## Task 1: Prereqs — bifrost CLI + install scaffold

**Files:** (ninguno propio; usa `chimeranext/bifrost-keeper` y scaffolda en el monorepo)

- [ ] **Step 1: Linkear el CLI bifrost-review**

Run:
```bash
cd ~/Documentos/GitHub/chimeranext/bifrost-keeper && bun link && cd -
```
Expected: registra `bifrost-review` en el PATH (symlink al clon).

- [ ] **Step 2: Verificar el CLI**

Run: `bifrost-review --help`
Expected: muestra usage con subcomandos `diff`, `pr`, `install`.

- [ ] **Step 3: Scaffold install en el monorepo**

Run:
```bash
cd /home/kvttvrsis/Documentos/GitHub/vertivolatam/monorepo && bifrost-review install
```
Expected: crea `.claude/commands/bifrost-local-review.md`, target Makefile, git alias, y agrega `*.nvidia.env` al `.gitignore`.

- [ ] **Step 4: Verificar el scaffold**

Run: `ls .claude/commands/bifrost-local-review.md && grep -q 'nvidia.env' .gitignore && echo OK`
Expected: `OK`.

- [ ] **Step 5: Commit**

```bash
git add .claude/commands/bifrost-local-review.md .gitignore Makefile 2>/dev/null
git commit -m "chore(tooling): scaffold bifrost-review (slash local + gitignore nvidia env)"
```

---

## Task 2: .gitignore — state file

**Files:** Modify: `.gitignore`

- [ ] **Step 1: Agregar el state file al gitignore**

Append a `.gitignore` (si la línea no existe ya):
```
.claude/.implement-prs
```

- [ ] **Step 2: Verificar**

Run: `grep -q '.claude/.implement-prs' .gitignore && echo OK`
Expected: `OK`.

- [ ] **Step 3: Commit**

```bash
git add .gitignore
git commit -m "chore: gitignore .claude/.implement-prs (state file del Stop hook)"
```

---

## Task 3: Linear hygiene helper — `scripts/linear/vrtv.sh`

**Files:**
- Create: `scripts/linear/vrtv.sh`

- [ ] **Step 1: Escribir el helper**

Create `scripts/linear/vrtv.sh`:
```bash
#!/usr/bin/env bash
# Linear hygiene helper para el workspace vertivolatam (team VRTV).
# El Linear MCP de la sesion esta en OTRO workspace -> usamos la GraphQL API
# directa con la key de ~/.config/linear/credentials.toml (NUNCA se imprime).
# Ref: memoria reference-linear-vertivolatam-api.
#
# Uso:
#   vrtv.sh get <VRTV-XXX>                       -> imprime JSON del issue
#   vrtv.sh ensure <VRTV-XXX>                    -> set project/assignee/priority si faltan
#   vrtv.sh set-state <VRTV-XXX> "In Progress"   -> flip estado + READ-BACK (exit!=0 si no aplico)
set -uo pipefail

API="https://api.linear.app/graphql"
PROJECT_500K="364bd82d-eb80-40bf-90b7-87a81cdcd16d"
LAPC506="bb711664-d14e-46da-bfc1-f4a53db31b25"
declare -A STATE=( ["In Progress"]="90542e22-d2c6-44c9-9da7-c7bb2179a0b9" \
                   ["In Review"]="4fccc74e-ab0e-46bb-9370-05ccb1b32e2a" \
                   ["Todo"]="53eb903c-97dd-46d0-a1a5-b6e4c1c46897" )

key() { grep -E '^\s*vertivolatam' ~/.config/linear/credentials.toml \
        | sed -E 's/^[^=]*=\s*"?([^"]+)"?\s*$/\1/'; }

gql() { # $1 = query/mutation json payload
  curl -s -X POST "$API" -H "Authorization: $(key)" \
       -H "Content-Type: application/json" -d "$1"; }

issue_id() { # VRTV-XXX -> uuid
  gql "{\"query\":\"query{issue(id:\\\"$1\\\"){id}}\"}" \
    | jq -r '.data.issue.id // empty'; }

cmd="${1:-}"; iss="${2:-}"
case "$cmd" in
  get)
    gql "{\"query\":\"query{issue(id:\\\"$iss\\\"){id identifier title state{name} assignee{displayName} project{name} priority}}\"}" ;;
  ensure)
    cur=$(gql "{\"query\":\"query{issue(id:\\\"$iss\\\"){project{id} assignee{id} priority}}\"}")
    pid=$(echo "$cur" | jq -r '.data.issue.project.id // empty')
    aid=$(echo "$cur" | jq -r '.data.issue.assignee.id // empty')
    pri=$(echo "$cur" | jq -r '.data.issue.priority // 0')
    upd=""
    [[ -z "$pid" ]] && upd="$upd projectId:\\\"$PROJECT_500K\\\""
    [[ -z "$aid" ]] && upd="$upd assigneeId:\\\"$LAPC506\\\""
    [[ "$pri" == "0" ]] && upd="$upd priority:3"
    if [[ -n "$upd" ]]; then
      id=$(issue_id "$iss")
      gql "{\"query\":\"mutation{issueUpdate(id:\\\"$id\\\",input:{$upd}){success}}\"}" >/dev/null
      echo "[vrtv] $iss: campos seteados ->$upd"
    else
      echo "[vrtv] $iss: project/assignee/priority OK"
    fi ;;
  set-state)
    target="${3:?falta estado}"; sid="${STATE[$target]:?estado desconocido}"
    id=$(issue_id "$iss")
    gql "{\"query\":\"mutation{issueUpdate(id:\\\"$id\\\",input:{stateId:\\\"$sid\\\"}){success}}\"}" >/dev/null
    # READ-BACK: el original noto no-ops silenciosos; verificamos siempre.
    got=$(gql "{\"query\":\"query{issue(id:\\\"$iss\\\"){state{name}}}\"}" | jq -r '.data.issue.state.name')
    if [[ "$got" == "$target" ]]; then echo "[vrtv] $iss -> $target (verificado)";
    else echo "[vrtv] PENDING-MANUAL: $iss quedo en '$got', target '$target'" >&2; exit 3; fi ;;
  *) echo "uso: vrtv.sh get|ensure|set-state <VRTV-XXX> [estado]" >&2; exit 2 ;;
esac
```

- [ ] **Step 2: Hacerlo ejecutable + shellcheck**

Run: `chmod +x scripts/linear/vrtv.sh && shellcheck scripts/linear/vrtv.sh || true`
Expected: ejecutable; shellcheck sin errores graves (warnings de `key` en subshell son aceptables).

- [ ] **Step 3: Smoke-test del read path (no muta)**

Run: `scripts/linear/vrtv.sh get VRTV-102 | jq -r '.data.issue.identifier,.data.issue.title'`
Expected: `VRTV-102` y el título de la épica. (Confirma auth + parsing sin tocar nada.)

- [ ] **Step 4: Commit**

```bash
git add scripts/linear/vrtv.sh
git commit -m "feat(tooling): helper Linear GraphQL para vertivolatam (get/ensure/set-state + read-back)"
```

---

## Task 4: Stop hook — `.claude/hooks/stop-prs-green.sh`

**Files:**
- Create: `.claude/hooks/stop-prs-green.sh`
- Test: `tests/hooks/test-stop-prs-green.sh`

- [ ] **Step 1: Escribir el test primero**

Create `tests/hooks/test-stop-prs-green.sh`:
```bash
#!/usr/bin/env bash
# Tests deterministas del Stop hook (sin red): solo los caminos fail-open.
set -uo pipefail
HOOK=".claude/hooks/stop-prs-green.sh"
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
fail=0

# Caso A: sin state file -> exit 0 (no bloquea).
( cd "$TMP" && mkdir -p .claude && bash "$OLDPWD/$HOOK" ); \
  [[ $? -eq 0 ]] && echo "A ok" || { echo "A FAIL"; fail=1; }

# Caso B: state file con threshold pero SIN PRs -> exit 0.
( cd "$TMP" && printf '4.5\n' > .claude/.implement-prs && bash "$OLDPWD/$HOOK" ); \
  [[ $? -eq 0 ]] && echo "B ok" || { echo "B FAIL"; fail=1; }

exit $fail
```

- [ ] **Step 2: Correr el test — debe fallar (hook no existe)**

Run: `bash tests/hooks/test-stop-prs-green.sh`
Expected: FAIL (el hook aún no existe / no es ejecutable).

- [ ] **Step 3: Escribir el hook**

Create `.claude/hooks/stop-prs-green.sh`:
```bash
#!/usr/bin/env bash
# Stop hook: hard enforcement para /ready-to-review-mergeable (port de dojo-os).
#
# Mientras exista `.claude/.implement-prs`, la sesion no puede terminar hasta que
# cada PR listado sea (a) no-Draft y (b) tenga un APPROVE con Confidence >= el
# umbral de la linea 1. ADAPTACION Vertivo: bifrost aun no tiene identidad de bot,
# asi que la review se detecta por MARCADOR EN EL BODY (linea "Confidence: X/5"),
# NO por login. (Cuando bifrost tenga GitHub App, se puede endurecer a login.)
#
# State file (`.claude/.implement-prs`):
#   linea 1 : umbral (float, ej. 4.5). Default 4.5 si falta/inparseable.
#   linea 2+: un PR# por linea.
#
# Contrato:
#   - Sin state file            -> exit 0 (nunca bloquea sesion normal).
#   - Todos verdes              -> borra el state file + exit 0.
#   - PR draft/sin-review/< umbral -> exit 2 con mensaje especifico (Stop API).
#   - gh/jq/red falla           -> exit 0 con warning (nunca bloquea por infra).
set -uo pipefail

STATE_FILE=".claude/.implement-prs"
DEFAULT_THRESHOLD="4.5"

[[ -f "$STATE_FILE" ]] || exit 0
command -v jq >/dev/null 2>&1 || { echo "[stop-prs-green] WARN: jq ausente; no bloqueo." >&2; exit 0; }
command -v gh >/dev/null 2>&1 || { echo "[stop-prs-green] WARN: gh ausente; no bloqueo." >&2; exit 0; }

THRESHOLD=$(sed -n '1p' "$STATE_FILE" | tr -d '[:space:]')
[[ "$THRESHOLD" =~ ^[0-9]+(\.[0-9]+)?$ ]] || THRESHOLD="$DEFAULT_THRESHOLD"

mapfile -t PR_NUMBERS < <(sed -n '2,$p' "$STATE_FILE" | grep -oE '[0-9]+')
[[ ${#PR_NUMBERS[@]} -eq 0 ]] && exit 0

block() {
  local pr="$1" reason="$2"
  echo "[stop-prs-green] BLOCKED: PR #${pr} ${reason}." >&2
  echo "  ready-to-review-mergeable exige que cada PR en ${STATE_FILE} sea no-draft" >&2
  echo "  y tenga un APPROVE con Confidence >= ${THRESHOLD} (review de bifrost)." >&2
  echo "  Lee los findings, arregla, push, corre 'bifrost-review pr ${pr} --post', e itera." >&2
  exit 2
}

ALL_GREEN=1
for pr in "${PR_NUMBERS[@]}"; do
  if ! PR_JSON=$(gh pr view "$pr" --json reviews,isDraft 2>/dev/null); then
    echo "[stop-prs-green] WARN: gh pr view #${pr} fallo; no bloqueo." >&2
    exit 0
  fi
  [[ "$(echo "$PR_JSON" | jq -r '.isDraft // false')" == "true" ]] && block "$pr" "es Draft"

  # Mejor Confidence entre reviews APPROVED cuyo body trae "Confidence: X/5".
  BEST=$(echo "$PR_JSON" | jq -r '
    [ .reviews[]
      | select(.state=="APPROVED")
      | (.body // "")
      | capture("Confidence:\\s*(?<c>[0-9]+(\\.[0-9]+)?)\\s*/\\s*5"; "i")
      | .c | tonumber
    ] | max // empty')

  if [[ -z "$BEST" ]]; then block "$pr" "sin review APPROVED con linea 'Confidence: X/5'"; fi
  if awk -v b="$BEST" -v t="$THRESHOLD" 'BEGIN{exit !(b < t)}'; then
    block "$pr" "Confidence ${BEST} < umbral ${THRESHOLD}"
  fi
done

# Todos verdes -> el comando es dueño del cleanup, pero el hook tambien limpia.
[[ "$ALL_GREEN" -eq 1 ]] && rm -f "$STATE_FILE"
exit 0
```

- [ ] **Step 4: Ejecutable + correr el test — debe pasar**

Run: `chmod +x .claude/hooks/stop-prs-green.sh && bash tests/hooks/test-stop-prs-green.sh`
Expected: `A ok` y `B ok`, exit 0.

- [ ] **Step 5: shellcheck**

Run: `shellcheck .claude/hooks/stop-prs-green.sh`
Expected: sin errores (warnings menores aceptables).

- [ ] **Step 6: Commit**

```bash
git add .claude/hooks/stop-prs-green.sh tests/hooks/test-stop-prs-green.sh
git commit -m "feat(hooks): stop-prs-green — enforce PRs APPROVED >= umbral (detecta bifrost por body-marker)"
```

---

## Task 4b: Pre-Linear-save hygiene hook — `.claude/hooks/pre-linear-save-issue-hygiene.sh`

> **Caveat Vertivo:** nuestro path de creación de issues VRTV es la API GraphQL (`vrtv.sh`),
> NO el MCP (workspace equivocado). Este hook es PreToolUse sobre `save_issue` del MCP → guarda
> el path MCP (evita crear issues medio-triadas / en el workspace equivocado vía MCP) y fuerza
> declarar intención de triage. El schema del plugin coincide con el original (`project`,
> `assignee`, `priority`, `labels`, `milestone`, `state`, `id`) → port casi verbatim; solo cambia
> el matcher al tool del plugin.

**Files:** Create: `.claude/hooks/pre-linear-save-issue-hygiene.sh`

- [ ] **Step 1: Escribir el hook** (port verbatim del original con wording Vertivo)

Create `.claude/hooks/pre-linear-save-issue-hygiene.sh`:
```bash
#!/usr/bin/env bash
# pre-linear-save-issue-hygiene.sh — PreToolUse hook sobre Linear MCP save_issue.
# Bloquea CREAR un issue sin triage completo — project, assignee, priority, labels,
# milestone y un state explicito no-Backlog — para que ninguno caiga en una vista
# huerfana/backlog con triage incompleto. Updates (con `id`) pasan sin tocar.
# Port de dojocoding/dojo-os; matcher = mcp__plugin_linear_linear__save_issue.
# NOTA: el path VRTV real es la API GraphQL (vrtv.sh); este hook guarda el path MCP.
set -euo pipefail

INPUT="$(cat)"
command -v jq >/dev/null 2>&1 || exit 0  # fail-open

TOOL_INPUT="$(printf '%s' "$INPUT" | jq -r '.tool_input // empty' 2>/dev/null)" || exit 0
[ -n "$TOOL_INPUT" ] || exit 0

HAS_ID="$(printf '%s' "$TOOL_INPUT" | jq -r 'has("id")' 2>/dev/null)" || exit 0
[ "$HAS_ID" = "true" ] && exit 0   # updates fuera de scope

MISSING=()
PROJECT="$(printf '%s' "$TOOL_INPUT" | jq -r '.project // empty')"
[ -n "$PROJECT" ] || MISSING+=("project (ej. \"Vertivo → \$500K MRR\")")
ASSIGNEE="$(printf '%s' "$TOOL_INPUT" | jq -r '.assignee // empty')"
[ -n "$ASSIGNEE" ] || MISSING+=("assignee (ej. \"me\")")
PRIORITY="$(printf '%s' "$TOOL_INPUT" | jq -r '.priority // 0')"
case "$PRIORITY" in 1|2|3|4) : ;; *) MISSING+=("priority (1=Urgent 2=High 3=Medium 4=Low — 0/ausente = vista no-priority)") ;; esac
LABELS_COUNT="$(printf '%s' "$TOOL_INPUT" | jq -r '(.labels // []) | if type=="array" then length else 0 end' 2>/dev/null)" || LABELS_COUNT=0
[ "${LABELS_COUNT:-0}" -ge 1 ] 2>/dev/null || MISSING+=("labels (al menos Type + Size — ver taxonomia AGENTS.md)")
MILESTONE="$(printf '%s' "$TOOL_INPUT" | jq -r '.milestone // empty')"
[ -n "$MILESTONE" ] || MISSING+=("milestone (el milestone del proyecto)")
STATE="$(printf '%s' "$TOOL_INPUT" | jq -r '.state // empty')"
if [ -z "$STATE" ]; then MISSING+=("state (explicito — \"Todo\"/\"In Progress\"; ausente = Backlog huerfano)")
elif [ "$(printf '%s' "$STATE" | tr '[:upper:]' '[:lower:]')" = "backlog" ]; then
  MISSING+=("state no debe ser \"Backlog\" — usar un estado accionable")
fi

if [ "${#MISSING[@]}" -gt 0 ]; then
  {
    echo "BLOCKED — higiene de issue Linear: todo CREATE debe declarar triage completo"
    echo "(project, assignee, priority, labels, milestone, state)."
    echo ""
    echo "Campos faltantes/invalidos en este save_issue CREATE:"
    for f in "${MISSING[@]}"; do echo "  - $f"; done
    echo ""
    echo "VERIFICAR post-write con get_issue — el MCP puede no-op silencioso en"
    echo "state/assignee/priority; reportar manual flips si pasa."
  } >&2
  exit 2
fi
exit 0
```

- [ ] **Step 2: Ejecutable + shellcheck**

Run: `chmod +x .claude/hooks/pre-linear-save-issue-hygiene.sh && shellcheck .claude/hooks/pre-linear-save-issue-hygiene.sh`
Expected: sin errores.

- [ ] **Step 3: Test del path "update pasa" y "create incompleto bloquea"**

Run:
```bash
# update (tiene id) -> exit 0
echo '{"tool_input":{"id":"VRTV-1","title":"x"}}' | bash .claude/hooks/pre-linear-save-issue-hygiene.sh; echo "update exit=$?"
# create sin triage -> exit 2
echo '{"tool_input":{"title":"x","team":"VRTV"}}' | bash .claude/hooks/pre-linear-save-issue-hygiene.sh; echo "create exit=$?"
```
Expected: `update exit=0` y `create exit=2` (con la lista de campos faltantes en stderr).

- [ ] **Step 4: Commit**

```bash
git add .claude/hooks/pre-linear-save-issue-hygiene.sh
git commit -m "feat(hooks): pre-linear-save-issue-hygiene — gate triage en save_issue del MCP (port dojo-os)"
```

---

## Task 5: Wiring de los hooks — `.claude/settings.json`

**Files:** Modify/Create: `.claude/settings.json`

- [ ] **Step 1: Agregar ambos hooks (Stop + PreToolUse)**

Si `.claude/settings.json` no existe, crearlo con:
```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          { "type": "command", "command": "${CLAUDE_PROJECT_ROOT}/.claude/hooks/stop-prs-green.sh" }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "mcp__plugin_linear_linear__save_issue",
        "hooks": [
          { "type": "command", "command": "${CLAUDE_PROJECT_ROOT}/.claude/hooks/pre-linear-save-issue-hygiene.sh" }
        ]
      }
    ]
  }
}
```
Si ya existe, agregar las claves `Stop` y `PreToolUse` (o sus elementos a los arrays existentes) sin pisar otras claves. **Verificar el nombre exacto del tool** en una sesión real (`/hooks` o el nombre que muestre el plugin Linear) por si difiere de `mcp__plugin_linear_linear__save_issue`.

- [ ] **Step 2: Verificar JSON válido**

Run: `python3 -c "import json;json.load(open('.claude/settings.json'));print('OK')"`
Expected: `OK`.

- [ ] **Step 3: Commit**

```bash
git add .claude/settings.json
git commit -m "chore(hooks): wire stop-prs-green (Stop) + pre-linear-save-issue-hygiene (PreToolUse)"
```

---

## Task 6: El slash command — `.claude/commands/ready-to-review-mergeable.md`

**Files:** Create: `.claude/commands/ready-to-review-mergeable.md`

- [ ] **Step 1: Escribir el comando**

Create `.claude/commands/ready-to-review-mergeable.md`:
```markdown
---
description: "Maneja issues VRTV hasta un PR Ready-for-Review APPROVED >= umbral (bifrost last-resort + CodeRabbit). No para hasta que todos esten verdes."
argument-hint: "<VRTV-XXXX [VRTV-YYYY ...]> [--confidence 4.5]"
---

# Ready To Review (Mergeable) — Vertivo

`$ARGUMENTS`

Maneja uno o mas issues VRTV hasta un PR **APPROVED y mergeable** cada uno, contra
`develop` (GitFlow), y no para hasta que cada PR este verde.

## Parse arguments
- Issue IDs: cada token `VRTV-XXXX` en `$ARGUMENTS` (un PR por issue).
- Umbral: `--confidence X.X` si esta presente, si no **4.5**. `--confidence` es el
  relajador: nunca subir por encima de lo que pidio el caller.

## Higiene Linear (por issue) — vía API GraphQL de vertivolatam
> El Linear MCP de la sesion esta en OTRO workspace (no VRTV). Usar el helper
> `scripts/linear/vrtv.sh` (GraphQL directo; la key nunca se imprime).

**On start (antes de implementar cada issue):**
1. `scripts/linear/vrtv.sh ensure VRTV-XXX` — setea project/assignee(lapc506)/priority si faltan.
2. `scripts/linear/vrtv.sh set-state VRTV-XXX "In Progress"` — flip + read-back. Si imprime
   `PENDING-MANUAL`, anotarlo para el reporte final (no asumir exito).

## Run the pipeline
Invoca **`make-no-mistakes:implement`** con los issue IDs parseados. Ese skill es dueño de:
- un worktree + una branch por issue (aislamiento),
- el loop de reviewers del repo (CodeRabbit primario),
- **HITL en push / PR / merge** (nunca auto-push, auto-open ni auto-merge sin la aprobacion
  por-accion que el repo exige).

## Per-PR contract
Cuando el skill abre cada PR:
1. **Ready for Review**, nunca Draft — salvo cambios cross-cutting (el repo los abre Draft;
   no correr el reviewer sobre un Draft).
2. Base = **`develop`**.
3. **Append el PR#** a `.claude/.implement-prs`. Crear el archivo si falta; su **primera linea
   es el umbral** (escribirla una vez, antes del primer PR#). Es el estado del Stop hook.

## Reviewer loop (primario -> last-resort bifrost)
- **Primario:** dejar que CodeRabbit (via el loop de `implement`) revise y resolver sus findings.
- **Last-resort bifrost (una vez, al final):** cuando el PR este casi-limpio (o si CodeRabbit
  esta rate-limited/caido/sin veredicto), correr **`bifrost-review pr <n> --post`** (NIM key via
  Infisical/env; `GITHUB_TOKEN` para postear) para obtener el APPROVE con `Confidence: X/5`.
  Correrlo **una sola vez** sobre un PR ya atendido minimiza el gasto NIM (~400k tokens/review,
  rate-limit a nivel de cuenta).
- **Si Confidence < umbral:** leer los findings, arreglar, push, re-correr `bifrost-review pr <n>
  --post`, iterar. No bajar la vara.

## Exit condition (el punto)
No estas listo hasta que *cada* PR en `.claude/.implement-prs` sea:
- no-Draft, **y**
- tenga una review **APPROVED** cuyo body traiga **`Confidence: X/5` con X >= umbral**.

Cuando un PR alcanza el umbral, flip su issue a **"In Review"**:
`scripts/linear/vrtv.sh set-state VRTV-XXX "In Review"` (read-back; **nunca "Done"** — es HITL del PO).

El Stop hook `stop-prs-green.sh` enforce esto: bloquea el fin de sesion mientras
`.claude/.implement-prs` liste algun PR draft, sin-review-APPROVED, o < umbral.

## On success
1. Borrar `.claude/.implement-prs` (el hook tambien lo limpia cuando todo esta verde).
2. Reportar una tabla, una fila por issue: **Issue -> PR -> Confidence -> Linear state**
   (marcando cada flip como **applied** o **PENDING-MANUAL**), y al final la lista
   "manual Linear flips pending" (`issue -> target state`) para lo que no aplico.
```

- [ ] **Step 2: Verificar frontmatter + parse**

Run: `head -4 .claude/commands/ready-to-review-mergeable.md | grep -q 'argument-hint' && echo OK`
Expected: `OK`.

- [ ] **Step 3: Commit**

```bash
git add .claude/commands/ready-to-review-mergeable.md
git commit -m "feat(commands): /ready-to-review-mergeable (bifrost last-resort + CodeRabbit, base develop, umbral 4.5)"
```

---

## Task 7: Verificación end-to-end (dry-run controlado)

**Files:** (ninguno — verificación manual)

- [ ] **Step 1: Reiniciar Claude Code para cargar el slash + hook**

El slash command y el Stop hook se descubren al iniciar la sesion. Reiniciar (o `/reload`).
Expected: `/ready-to-review-mergeable` aparece en la lista de comandos.

- [ ] **Step 2: Smoke del hook con un PR no-verde simulado**

Run:
```bash
printf '4.5\n999999\n' > .claude/.implement-prs
bash .claude/hooks/stop-prs-green.sh; echo "exit=$?"
rm -f .claude/.implement-prs
```
Expected: el hook intenta `gh pr view 999999`, falla la red/PR inexistente → `exit=0` (fail-open con WARN). (Confirma que no bloquea por infra.)

- [ ] **Step 3: Dry-run del comando sobre un issue trivial**

Invocar `/ready-to-review-mergeable VRTV-XXX --confidence 4.0` con un issue de prueba pequeño.
Expected: (a) `vrtv.sh ensure` + `set-state In Progress` con read-back verificado; (b)
`make-no-mistakes:implement` arranca worktree+branch; (c) al abrir PR, base=`develop`,
Ready-for-Review, PR# en `.claude/.implement-prs` con `4.0` en la 1ª línea.

- [ ] **Step 4: Verificar el gate**

Con el PR abierto, correr `bifrost-review pr <n> --post`. Confirmar que aparece una review
APPROVED/REQUEST_CHANGES con `Confidence: X/5`, y que el hook (al intentar cerrar sesión)
bloquea si X < 4.0 y deja pasar si X >= 4.0.

- [ ] **Step 5: Commit del registro de verificación (opcional)**

Si se documenta el resultado, agregarlo a `docs/superpowers/plans/` o cerrar sin commit.

---

## Self-review notes (cobertura del spec)

- Reviewer primario+last-resort → Task 6 (loop) + Task 4 (gate por Confidence). ✔
- Detección por body-marker (sin login) → Task 4 jq `capture("Confidence:...")`. ✔
- Linear vía GraphQL vertivolatam (no MCP) → Task 3 helper + Task 6 hygiene. ✔
- Base `develop` → Task 6 per-PR contract. ✔
- Umbral 4.5 default → Task 4 (`DEFAULT_THRESHOLD`) + Task 6 (parse). ✔
- Stop hook portado + adaptado → Task 4 + Task 5 wiring. ✔
- pre-linear-save-issue-hygiene portado (matcher plugin save_issue, schema verificado) → Task 4b + Task 5 wiring. ✔
- Prereqs bifrost (bun link + install) → Task 1. ✔
- State file gitignored → Task 2. ✔
- make-no-mistakes:implement reusado → Task 6. ✔
```
