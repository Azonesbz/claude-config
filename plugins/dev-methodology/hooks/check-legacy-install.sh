#!/usr/bin/env bash
# SessionStart hook: shout when the retired install.sh's copies are still in
# ~/.claude/. Claude Code loads ~/.claude/rules/ in every session, so those
# copies shadow this plugin: the methodology that applies is the one frozen on
# install day, and nothing else signals it. Silence here is the failure mode --
# the install looks fine, so the member never goes looking.
set -uo pipefail

CONFIG_DIR="${CLAUDE_CONFIG_DIR:-${HOME}/.claude}"

# The exact names install.sh deployed, each one now shipped by the plugin.
# Matching this exact set -- rather than "rules/ exists" -- is what keeps a
# member's own rules and agents from tripping the alarm.
LEGACY_RULES="clean-code code-organization code-review-and-quality flow
incremental-implementation scalability-and-boundaries test-driven-development"
LEGACY_AGENTS="conventional-commit factorizer linear mobile-preview
store-deployer test-builder test-runner verifier"

# Print every legacy path still present under $1, one relative path per line.
find_leftovers() {
  local cfg="$1" name file
  for name in ${LEGACY_RULES}; do
    [ -f "${cfg}/rules/${name}.md" ] && printf 'rules/%s.md\n' "${name}"
  done
  for name in ${LEGACY_AGENTS}; do
    [ -f "${cfg}/agents/${name}.md" ] && printf 'agents/%s.md\n' "${name}"
  done
  [ -f "${cfg}/commands/flow.md" ] && printf 'commands/flow.md\n'
  for file in "${cfg}"/hooks/guard-*.sh; do
    [ -f "${file}" ] && printf 'hooks/%s\n' "$(basename "${file}")"
  done
  return 0
}

# A SessionStart hook's stdout is appended to the session context, so the alert
# is addressed to the model: a warning the user never reads changes nothing.
print_alert() {
  local leftovers="$1"
  printf '%s\n' \
    "" \
    "## /!\\ dev-methodology : DOUBLON DETECTE - methodo PERIMEE active" \
    "" \
    "L'ancien install.sh a laisse ses copies dans ${CONFIG_DIR}. Claude Code" \
    "charge ~/.claude/rules/ d'office : elles DOUBLONNENT ce plugin et GAGNENT" \
    "sur lui. La methodo appliquee dans cette session est celle du jour de" \
    "l'install, pas celle de la marketplace." \
    "" \
    "Restes de l'ancienne install :"
  printf '%s\n' "${leftovers}" | sed 's|^|  - |'
  printf '%s\n' \
    "" \
    "-> Signale-le a l'utilisateur des maintenant, avant toute autre chose." \
    "   Le correctif est la section Migration du README du plugin :" \
    "   https://github.com/Azonesbz/claude-config" \
    ""
}

leftovers="$(find_leftovers "${CONFIG_DIR}")"
[ -n "${leftovers}" ] && print_alert "${leftovers}"
exit 0
