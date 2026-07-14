#!/usr/bin/env bash
# Shared helpers for PreToolUse guard hooks.
# Sourced (not executed) by guard-*.sh. The full hook JSON is read by the
# caller into $HOOK_INPUT before calling hook_field.

# Name of a usable Python interpreter, empty when there is none.
#
# Both spellings must be tried: the Windows installer lays down `python` and no
# `python3` at all. Probing only `python3` therefore left every Windows machine
# without jq silently unguarded -- the exact failure this file warns about.
hook_python() {
  local candidate
  for candidate in python3 python; do
    if command -v "${candidate}" >/dev/null 2>&1; then
      printf '%s' "${candidate}"
      return 0
    fi
  done
  return 1
}

# Print tool_input.<key> from $HOOK_INPUT. Returns 1 when no JSON parser is
# available so the caller can fail open (never break the user's workflow).
#
# Failing open is deliberate, but it must never be silent: a guard that quietly
# stops guarding is worse than no guard, because the team believes it is covered.
# Neither jq nor Python ships with Claude Code, so this branch is reachable.
# The warning names the fix.
hook_field() {
  local key="$1" py
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "${HOOK_INPUT}" | jq -r --arg k "${key}" '.tool_input[$k] // empty'
    return 0
  fi
  if py="$(hook_python)"; then
    printf '%s' "${HOOK_INPUT}" | "${py}" -c 'import sys, json
data = json.load(sys.stdin)
print(data.get("tool_input", {}).get(sys.argv[1], ""))' "${key}"
    return 0
  fi
  hook_warn_no_parser
  return 1
}

# Warn once per session that the guards are inert. A marker file in the plugin's
# persistent data dir keeps this to one line instead of one per tool call.
hook_warn_no_parser() {
  local marker="${CLAUDE_PLUGIN_DATA:-${TMPDIR:-/tmp}}/.no-json-parser-warned"
  [ -e "${marker}" ] && return 0
  mkdir -p "$(dirname "${marker}")" 2>/dev/null || true
  : > "${marker}" 2>/dev/null || true
  printf '%s\n' \
    "dev-methodology: guards INACTIFS — ni jq ni python/python3 sur le PATH." \
    "  git add -A, les force-push et les fichiers de plan ne sont PAS bloques." \
    "  Corriger : installer jq (brew/apt/winget install jqlang.jq) ou Python 3." >&2
}

# Emit a PreToolUse "deny" decision and exit 0 (Claude Code then blocks the
# call). Reason must be plain ASCII without double-quotes or backslashes.
hook_deny() {
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' "$1"
  exit 0
}
