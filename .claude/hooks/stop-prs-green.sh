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

# Contrato linea 2+: UNA linea por PR, exactamente el numero (prefijo '#' opcional),
# nada mas. Lineas que no son solo-numero se IGNORAN (evita matchear digitos sueltos
# de texto como 'feat(123): x').
mapfile -t PR_NUMBERS < <(sed -n '2,$p' "$STATE_FILE" | sed -E 's/^[[:space:]]*#?([0-9]+)[[:space:]]*$/\1/;t;d')
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
