#!/usr/bin/env bash
# AAA tests for guard-git-add.sh — whole-tree staging must be blocked,
# targeted staging must pass through untouched.
set -uo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
guard="${dir}/guard-git-add.sh"
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

check_blocked "git add -A"        "git add -A"
check_blocked "git add --all"     "git add --all"
check_blocked "git add ."         "git add ."
check_blocked "git add -A . tail" "git add -A ."
check_allowed "targeted path"     "git add rules/flow.md"
check_allowed "targeted subpath"  "git add ./hooks/guard-git-add.sh"
check_allowed "compound w/ cd ."  "git add hooks/x.sh && cd ."
check_allowed "non-add command"   "git status"

exit "${fails}"
