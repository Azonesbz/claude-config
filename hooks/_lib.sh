#!/usr/bin/env bash
# Shared helpers for PreToolUse guard hooks.
# Sourced (not executed) by guard-*.sh. The full hook JSON is read by the
# caller into $HOOK_INPUT before calling hook_field.

# Print tool_input.<key> from $HOOK_INPUT. Returns 1 when no JSON parser is
# available so the caller can fail open (never break the user's workflow).
hook_field() {
  local key="$1"
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "${HOOK_INPUT}" | jq -r --arg k "${key}" '.tool_input[$k] // empty'
  elif command -v python3 >/dev/null 2>&1; then
    printf '%s' "${HOOK_INPUT}" | python3 -c 'import sys, json
data = json.load(sys.stdin)
print(data.get("tool_input", {}).get(sys.argv[1], ""))' "${key}"
  else
    return 1
  fi
}

# Emit a PreToolUse "deny" decision and exit 0 (Claude Code then blocks the
# call). Reason must be plain ASCII without double-quotes or backslashes.
hook_deny() {
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' "$1"
  exit 0
}
