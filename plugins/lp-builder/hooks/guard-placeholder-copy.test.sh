#!/usr/bin/env bash
# AAA tests for guard-placeholder-copy.sh — writing filler copy must be blocked;
# real copy must pass through.
set -uo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
guard="${dir}/guard-placeholder-copy.sh"
fails=0

run_guard() { printf '%s' "$1" | "${guard}"; }
is_deny() { printf '%s' "$1" | grep -q '"permissionDecision":"deny"'; }

check_blocked() {
  # Arrange
  local label="$1" field="$2" text="$3"
  local input="{\"tool_name\":\"Write\",\"tool_input\":{\"${field}\":\"${text}\"}}"
  # Act
  local out; out="$(run_guard "${input}")"
  # Assert
  if is_deny "${out}"; then echo "PASS: blocked ${label}"; else
    echo "FAIL: expected block for ${label} (got: ${out})"; fails=$((fails + 1)); fi
}

check_allowed() {
  # Arrange
  local label="$1" field="$2" text="$3"
  local input="{\"tool_name\":\"Edit\",\"tool_input\":{\"${field}\":\"${text}\"}}"
  # Act
  local out; out="$(run_guard "${input}")"
  # Assert
  if [ -z "${out}" ]; then echo "PASS: allowed ${label}"; else
    echo "FAIL: expected pass-through for ${label} (got: ${out})"; fails=$((fails + 1)); fi
}

check_blocked "lorem ipsum in content"   "content"    "<p>Lorem ipsum dolor sit amet</p>"
check_blocked "lowercase lorem ipsum"    "content"    "lorem ipsum dolor"
check_blocked "uppercase LOREM IPSUM"    "content"    "LOREM IPSUM DOLOR"
check_blocked "filler in an Edit"        "new_string" "<h2>Lorem ipsum</h2>"
check_allowed "real hero copy"           "new_string" "<h1>Facture reglee en 48 heures</h1>"
check_allowed "explicit TODO placeholder" "new_string" "<p>TODO: temoignage client a fournir</p>"
check_allowed "the word lorem alone"     "new_string" "<p>Lorem Industries, notre client</p>"

exit "${fails}"
