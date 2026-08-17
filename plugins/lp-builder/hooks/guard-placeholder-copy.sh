#!/usr/bin/env bash
# PreToolUse(Write|Edit) guard: keep filler copy out of a landing page.
# The ui-snapping and conversion-anatomy skills forbid shipping a section with the
# demo content of the component it came from. Lorem ipsum is the one form of filler
# a string match can recognise with certainty, so it is the one this guard blocks.
#
# Scoped to page markup only. The plugin installs globally, so an unscoped match
# would deny lorem ipsum everywhere it is legitimate — test fixtures, seed scripts,
# Storybook stories, and the very documentation describing this guard.
set -euo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=_lib.sh
. "${dir}/_lib.sh"

HOOK_INPUT="$(cat)"
file_path="$(hook_field file_path)" || exit 0  # no JSON parser -> fail open

# Filler is only a defect in a file that renders to the visitor. Anywhere else
# it is ordinary sample data, so the guard stays out of the way.
case "${file_path}" in
  *.html | *.htm | *.jsx | *.tsx | *.vue | *.svelte | *.astro) ;;
  *) exit 0 ;;
esac

# Sample data belongs in tests, stories and fixtures — even inside page markup.
case "${file_path}" in
  *.test.* | *.spec.* | *.stories.* | */__tests__/* | */__mocks__/* | */fixtures/* | */mocks/*)
    exit 0
    ;;
esac

# Only the text being written matters — existing filler elsewhere in the file
# is the reviewer's job, not this guard's.
written="$(hook_written_text)" || exit 0

if printf '%s' "${written}" | grep -qiE 'lorem[[:space:]]+ipsum'; then
  hook_deny "Blocked by lp-builder: filler copy (lorem ipsum) must never be written into a landing page. Inject the real copy, or mark an explicit TODO placeholder the client can see (see the ui-snapping skill)."
fi
exit 0
