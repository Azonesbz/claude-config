#!/usr/bin/env bash
# PreToolUse(Bash) guard: block whole-tree staging.
# rules/flow.md mandates targeted `git add <paths>` and forbids `git add -A`,
# `--all` or `.` so each commit stages only the files of the current task.
set -euo pipefail

readonly WHOLE_TREE_ADD='git[[:space:]]+add[[:space:]]+([^&|;]*[[:space:]])?(-A|--all|\.|:/)([[:space:]]|$)'

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=_lib.sh
. "${dir}/_lib.sh"

HOOK_INPUT="$(cat)"
command_str="$(hook_field command)" || exit 0  # no JSON parser -> fail open

if printf '%s' "${command_str}" | grep -Eq "${WHOLE_TREE_ADD}"; then
  hook_deny "Blocked by flow rules: stage only this task's files with git add <path>, never git add -A / --all / . (see rules/flow.md)."
fi
exit 0
