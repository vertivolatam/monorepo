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

# tj <jq-filter> — extrae un campo del tool_input (un solo lugar para el patron printf|jq).
tj() { printf '%s' "$TOOL_INPUT" | jq -r "$1" 2>/dev/null; }

TOOL_INPUT="$(printf '%s' "$INPUT" | jq -r '.tool_input // empty' 2>/dev/null)" || exit 0
[ -n "$TOOL_INPUT" ] || exit 0

[ "$(tj 'has("id")')" = "true" ] && exit 0   # updates (con id) fuera de scope

MISSING=()
[ -n "$(tj '.project // empty')" ] || MISSING+=("project (ej. \"Vertivo → \$500K MRR\")")
[ -n "$(tj '.assignee // empty')" ] || MISSING+=("assignee (ej. \"me\")")
case "$(tj '.priority // 0')" in 1|2|3|4) : ;; *) MISSING+=("priority (1=Urgent 2=High 3=Medium 4=Low — 0/ausente = vista no-priority)") ;; esac
LABELS_COUNT="$(tj '(.labels // []) | if type=="array" then length else 0 end')" || LABELS_COUNT=0
[ "${LABELS_COUNT:-0}" -ge 1 ] 2>/dev/null || MISSING+=("labels (al menos Type + Size — ver taxonomia AGENTS.md)")
[ -n "$(tj '.milestone // empty')" ] || MISSING+=("milestone (el milestone del proyecto)")
STATE="$(tj '.state // empty')"
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
