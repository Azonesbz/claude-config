#!/usr/bin/env bash
# AAA tests for check-legacy-install.sh — leftovers from the retired install.sh
# must raise the alert; a member's own rules and agents must stay silent.
set -uo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
check="${dir}/check-legacy-install.sh"
fails=0

# Build a throwaway ~/.claude holding exactly the given relative paths.
make_config() {
  local cfg rel
  cfg="$(mktemp -d)"
  for rel in "$@"; do
    mkdir -p "${cfg}/$(dirname "${rel}")"
    : > "${cfg}/${rel}"
  done
  printf '%s' "${cfg}"
}

run_check() { CLAUDE_CONFIG_DIR="$1" bash "${check}"; }
is_alert() { printf '%s' "$1" | grep -q 'DOUBLON'; }

pass() { echo "PASS: $1"; }
fail() { echo "FAIL: $1"; fails=$((fails + 1)); }

check_alerts() {
  # Arrange
  local label="$1" cfg out; shift
  cfg="$(make_config "$@")"
  # Act
  out="$(run_check "${cfg}")"
  # Assert
  if is_alert "${out}"; then pass "alerts on ${label}"
  else fail "expected alert for ${label} (got: ${out})"; fi
  rm -rf "${cfg}"
}

check_silent() {
  # Arrange
  local label="$1" cfg out; shift
  cfg="$(make_config "$@")"
  # Act
  out="$(run_check "${cfg}")"
  # Assert
  if [ -z "${out}" ]; then pass "silent on ${label}"
  else fail "expected silence for ${label} (got: ${out})"; fi
  rm -rf "${cfg}"
}

check_names_offender() {
  # Arrange
  local cfg out
  cfg="$(make_config "rules/flow.md")"
  # Act
  out="$(run_check "${cfg}")"
  # Assert
  if printf '%s' "${out}" | grep -q 'rules/flow.md'; then pass "alert names the offending file"
  else fail "alert should name rules/flow.md (got: ${out})"; fi
  rm -rf "${cfg}"
}

check_silent_when_no_config_dir() {
  # Arrange
  local cfg="/nonexistent-claude-config-$$" out
  # Act
  out="$(run_check "${cfg}")"
  # Assert
  if [ -z "${out}" ]; then pass "silent when the config dir is absent"
  else fail "expected silence for a missing config dir (got: ${out})"; fi
}

# install.sh leftovers -> the plugin is being shadowed, say so.
check_alerts "legacy rule"        "rules/flow.md"
check_alerts "legacy rule set"    "rules/clean-code.md" "rules/test-driven-development.md"
check_alerts "legacy agent"       "agents/factorizer.md"
check_alerts "legacy command"     "commands/flow.md"
check_alerts "legacy guard hook"  "hooks/guard-git-add.sh"
check_alerts "one legacy among personal files" "rules/my-own-rule.md" "agents/verifier.md"

# A member's own config is none of our business — never cry wolf.
check_silent "empty config dir"
check_silent "personal rules only"   "rules/my-own-rule.md" "rules/team-postgres.md"
check_silent "personal agents only"  "agents/my-own-agent.md"
check_silent "unrelated command"     "commands/deploy.md"
check_silent "settings and memory"   "settings.json" "CLAUDE.md"
check_silent "plugin cache"          "plugins/repos/Azonesbz/claude-config/README.md"

check_names_offender
check_silent_when_no_config_dir

exit "${fails}"
