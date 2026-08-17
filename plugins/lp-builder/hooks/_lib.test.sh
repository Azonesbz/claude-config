#!/usr/bin/env bash
# AAA tests for _lib.sh — the fail-open path must stay open (never break the
# user's workflow) but must never stay silent, or the team believes it is
# guarded when it is not. Neither jq nor python3 ships with Claude Code, so
# this path is reachable in the field, typically on Windows Git Bash.
#
# This plugin ships its own copy of _lib.sh so it stands alone; the copy differs
# from the dev-methodology one in its warning text and marker name, which is
# exactly what these tests pin down.
set -uo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
guard="${dir}/guard-placeholder-copy.sh"
fails=0

# A PATH holding only the builtins the guard needs — no jq, no python3.
make_parserless_path() {
  local bin; bin="$(mktemp -d)"
  local p
  for tool in bash cat printf grep dirname mkdir rm command sed; do
    p="$(command -v "${tool}" 2>/dev/null)" && ln -sf "${p}" "${bin}/${tool}" 2>/dev/null
  done
  printf '%s' "${bin}"
}

# A payload the guard WOULD deny if it could parse it: filler copy in page markup.
run_without_parser() {
  local data_dir="$1" out_file="$2" err_file="$3"
  printf '%s' '{"tool_name":"Write","tool_input":{"file_path":"index.html","content":"<p>Lorem ipsum</p>"}}' |
    env -i PATH="${PARSERLESS_PATH}" CLAUDE_PLUGIN_DATA="${data_dir}" \
      bash "${guard}" >"${out_file}" 2>"${err_file}"
}

PARSERLESS_PATH="$(make_parserless_path)"
trap 'rm -rf "${PARSERLESS_PATH}"' EXIT

test_fails_open_without_parser() {
  # Arrange
  local tmp; tmp="$(mktemp -d)"
  # Act
  run_without_parser "${tmp}/data" "${tmp}/out" "${tmp}/err"
  local code=$?
  # Assert
  if [ "${code}" -eq 0 ] && [ ! -s "${tmp}/out" ]; then
    echo "PASS: fails open without a JSON parser (workflow not broken)"
  else
    echo "FAIL: expected exit 0 and no deny (exit=${code}, out=$(cat "${tmp}/out"))"
    fails=$((fails + 1))
  fi
  rm -rf "${tmp}"
}

test_warns_when_inert() {
  # Arrange
  local tmp; tmp="$(mktemp -d)"
  # Act
  run_without_parser "${tmp}/data" "${tmp}/out" "${tmp}/err"
  # Assert
  if grep -q 'garde INACTIF' "${tmp}/err"; then
    echo "PASS: warns on stderr that the guard is inert"
  else
    echo "FAIL: expected a warning on stderr (got: $(cat "${tmp}/err"))"
    fails=$((fails + 1))
  fi
  rm -rf "${tmp}"
}

test_warns_only_once() {
  # Arrange
  local tmp; tmp="$(mktemp -d)"
  run_without_parser "${tmp}/data" "${tmp}/out" "${tmp}/err"
  # Act
  run_without_parser "${tmp}/data" "${tmp}/out2" "${tmp}/err2"
  # Assert
  if [ ! -s "${tmp}/err2" ]; then
    echo "PASS: does not repeat the warning on every tool call"
  else
    echo "FAIL: expected silence on the second call (got: $(cat "${tmp}/err2"))"
    fails=$((fails + 1))
  fi
  rm -rf "${tmp}"
}

test_marker_does_not_collide_with_the_other_plugin() {
  # Arrange — dev-methodology already warned in this shared data dir.
  local tmp; tmp="$(mktemp -d)"
  mkdir -p "${tmp}/data"
  : > "${tmp}/data/.no-json-parser-warned"
  # Act
  run_without_parser "${tmp}/data" "${tmp}/out" "${tmp}/err"
  # Assert
  if grep -q 'garde INACTIF' "${tmp}/err"; then
    echo "PASS: warns despite the other plugin's marker (own marker name)"
  else
    echo "FAIL: expected its own warning, got: $(cat "${tmp}/err")"
    fails=$((fails + 1))
  fi
  rm -rf "${tmp}"
}

test_fails_open_without_parser
test_warns_when_inert
test_warns_only_once
test_marker_does_not_collide_with_the_other_plugin

exit "${fails}"
