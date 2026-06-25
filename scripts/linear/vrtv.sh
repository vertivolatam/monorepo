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
