#!/usr/bin/env bash
# PreToolUse(Write|Edit) guard: keep plan files out of the repo.
# rules/flow.md forbids committing plan.json (or equivalents) — the plan lives
# in the conversation thread, never in the source tree.
set -euo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=_lib.sh
. "${dir}/_lib.sh"

HOOK_INPUT="$(cat)"
file_path="$(hook_field file_path)" || exit 0  # no JSON parser -> fail open

case "$(basename "${file_path}")" in
  plan.json | plan.yaml | plan.yml)
    hook_deny "Blocked by flow rules: plan files (plan.json/yaml/yml) must never be written into the repo (see rules/flow.md). Keep the plan in the conversation thread."
    ;;
esac
exit 0
