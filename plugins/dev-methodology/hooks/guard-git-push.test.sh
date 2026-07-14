#!/usr/bin/env bash
# AAA tests for guard-git-push.sh — force pushes must be blocked, ordinary
# pushes must pass through.
set -uo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
guard="${dir}/guard-git-push.sh"
fails=0

run_guard() { printf '%s' "$1" | "${guard}"; }
is_deny() { printf '%s' "$1" | grep -q '"permissionDecision":"deny"'; }

check_blocked() {
  # Arrange
  local label="$1" command_json="$2"
  local input="{\"tool_name\":\"Bash\",\"tool_input\":{\"command\":\"${command_json}\"}}"
  # Act
  local out; out="$(run_guard "${input}")"
  # Assert
  if is_deny "${out}"; then echo "PASS: blocked ${label}"; else
    echo "FAIL: expected block for ${label} (got: ${out})"; fails=$((fails + 1)); fi
}

check_allowed() {
  # Arrange
  local label="$1" command_json="$2"
  local input="{\"tool_name\":\"Bash\",\"tool_input\":{\"command\":\"${command_json}\"}}"
  # Act
  local out; out="$(run_guard "${input}")"
  # Assert
  if [ -z "${out}" ]; then echo "PASS: allowed ${label}"; else
    echo "FAIL: expected pass-through for ${label} (got: ${out})"; fails=$((fails + 1)); fi
}

check_blocked "--force"            "git push --force"
check_blocked "--force-with-lease" "git push --force-with-lease"
check_blocked "-f short"           "git push -f"
check_blocked "trailing --force"   "git push origin main --force"
check_allowed "plain push"         "git push"
check_allowed "push to remote"     "git push origin main"
check_allowed "set upstream"       "git push -u origin feat/enforcement-hooks"
check_allowed "non-push command"   "git fetch --all"

exit "${fails}"
