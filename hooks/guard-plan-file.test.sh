#!/usr/bin/env bash
# AAA tests for guard-plan-file.sh — writing a plan file into the repo must be
# blocked; ordinary files must pass through.
set -uo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
guard="${dir}/guard-plan-file.sh"
fails=0

run_guard() { printf '%s' "$1" | "${guard}"; }
is_deny() { printf '%s' "$1" | grep -q '"permissionDecision":"deny"'; }

check_blocked() {
  # Arrange
  local label="$1" file_path="$2"
  local input="{\"tool_name\":\"Write\",\"tool_input\":{\"file_path\":\"${file_path}\"}}"
  # Act
  local out; out="$(run_guard "${input}")"
  # Assert
  if is_deny "${out}"; then echo "PASS: blocked ${label}"; else
    echo "FAIL: expected block for ${label} (got: ${out})"; fails=$((fails + 1)); fi
}

check_allowed() {
  # Arrange
  local label="$1" file_path="$2"
  local input="{\"tool_name\":\"Edit\",\"tool_input\":{\"file_path\":\"${file_path}\"}}"
  # Act
  local out; out="$(run_guard "${input}")"
  # Assert
  if [ -z "${out}" ]; then echo "PASS: allowed ${label}"; else
    echo "FAIL: expected pass-through for ${label} (got: ${out})"; fails=$((fails + 1)); fi
}

check_blocked "plan.json"          "plan.json"
check_blocked "nested plan.json"   "features/auth/plan.json"
check_blocked "plan.yaml"          "plan.yaml"
check_blocked "plan.yml"           "plan.yml"
check_allowed "rule file"          "rules/flow.md"
check_allowed "myplan.json"        "src/myplan.json"
check_allowed "plan.md doc"        "docs/plan.md"
check_allowed "planning dir"       "docs/planning/notes.md"

exit "${fails}"
