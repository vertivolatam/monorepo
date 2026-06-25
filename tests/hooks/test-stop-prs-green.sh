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
