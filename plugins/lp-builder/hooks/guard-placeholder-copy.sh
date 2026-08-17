#!/usr/bin/env bash
# PreToolUse(Write|Edit) guard: keep filler copy out of a landing page.
# The ui-snapping and conversion-anatomy skills forbid shipping a section with the
# demo content of the component it came from. Lorem ipsum is the one form of filler
# a string match can recognise with certainty, so it is the one this guard blocks.
set -euo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=_lib.sh
. "${dir}/_lib.sh"

HOOK_INPUT="$(cat)"

# Write carries the whole file in `content`; Edit carries the replacement in
# `new_string`. Only the text being written matters — existing filler elsewhere
# in the file is the reviewer's job, not this guard's.
written="$(hook_field content)" || exit 0  # no JSON parser -> fail open
[ -n "${written}" ] || written="$(hook_field new_string)" || exit 0

if printf '%s' "${written}" | grep -qiE 'lorem[[:space:]]+ipsum'; then
  hook_deny "Blocked by lp-builder: filler copy (lorem ipsum) must never be written into a landing page. Inject the real copy, or mark an explicit TODO placeholder the client can see (see the ui-snapping skill)."
fi
exit 0
