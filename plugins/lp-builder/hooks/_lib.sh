#!/usr/bin/env bash
# Shared helpers for lp-builder PreToolUse guard hooks.
# Sourced (not executed) by guard-*.sh. The full hook JSON is read by the
# caller into $HOOK_INPUT before calling hook_field.

# Print tool_input.<key> from $HOOK_INPUT. Returns 1 when no JSON parser is
# available so the caller can fail open (never break the user's workflow).
#
# Failing open is deliberate, but it must never be silent: a guard that quietly
# stops guarding is worse than no guard, because the team believes it is covered.
# Neither jq nor python3 ships with Claude Code, so this branch is reachable —
# typically on Windows Git Bash. The warning names the fix.
hook_field() {
  local key="$1"
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "${HOOK_INPUT}" | jq -r --arg k "${key}" '.tool_input[$k] // empty'
  elif command -v python3 >/dev/null 2>&1; then
    printf '%s' "${HOOK_INPUT}" | python3 -c 'import sys, json
data = json.load(sys.stdin)
print(data.get("tool_input", {}).get(sys.argv[1], ""))' "${key}"
  else
    hook_warn_no_parser
    return 1
  fi
}

# Warn once per session that the guards are inert. A marker file in the plugin's
# persistent data dir keeps this to one line instead of one per tool call.
hook_warn_no_parser() {
  local marker="${CLAUDE_PLUGIN_DATA:-${TMPDIR:-/tmp}}/.lp-no-json-parser-warned"
  [ -e "${marker}" ] && return 0
  mkdir -p "$(dirname "${marker}")" 2>/dev/null || true
  : > "${marker}" 2>/dev/null || true
  printf '%s\n' \
    "lp-builder: garde INACTIF — ni jq ni python3 trouves sur le PATH." \
    "  Le texte de remplissage (lorem ipsum) n'est PAS bloque a l'ecriture." \
    "  Corriger : installer jq (brew/apt/winget install jqlang.jq) ou python3." >&2
}

# Emit a PreToolUse "deny" decision and exit 0 (Claude Code then blocks the
# call). Reason must be plain ASCII without double-quotes or backslashes.
hook_deny() {
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' "$1"
  exit 0
}
