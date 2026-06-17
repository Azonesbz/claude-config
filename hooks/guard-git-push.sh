#!/usr/bin/env bash
# PreToolUse(Bash) guard: block force pushes.
# rules/flow.md forbids `git push --force` and `--force-with-lease` unless the
# user explicitly asked for it, to protect shared history on origin.
set -euo pipefail

readonly FORCE_PUSH='git[[:space:]]+push[[:space:]]+([^&|;]*[[:space:]])?(--force-with-lease|--force|-[A-Za-z]*f[A-Za-z]*)([[:space:]]|$)'

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=_lib.sh
. "${dir}/_lib.sh"

HOOK_INPUT="$(cat)"
command_str="$(hook_field command)" || exit 0  # no JSON parser -> fail open

if printf '%s' "${command_str}" | grep -Eq "${FORCE_PUSH}"; then
  hook_deny "Blocked by flow rules: force-push (--force / --force-with-lease) needs an explicit go from the user (see rules/flow.md). Push without --force or ask first."
fi
exit 0
