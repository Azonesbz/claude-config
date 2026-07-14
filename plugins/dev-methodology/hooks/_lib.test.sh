#!/usr/bin/env bash
# AAA tests for _lib.sh — the fail-open path must stay open (never break the
# user's workflow) but must never stay silent, or the team believes it is
# guarded when it is not. Neither jq nor python3 ships with Claude Code, so
# this path is reachable in the field, typically on Windows Git Bash.
set -uo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
guard="${dir}/guard-git-add.sh"
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

run_without_parser() {
  local data_dir="$1" out_file="$2" err_file="$3"
  printf '%s' '{"tool_name":"Bash","tool_input":{"command":"git add -A"}}' |
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
  if grep -q 'guards INACTIFS' "${tmp}/err"; then
    echo "PASS: warns on stderr that the guards are inert"
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

test_fails_open_without_parser
test_warns_when_inert
test_warns_only_once

exit "${fails}"
