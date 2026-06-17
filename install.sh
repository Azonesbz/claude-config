#!/usr/bin/env bash
# Sync claude-config repo content into ~/.claude/
# Usage (bash / git-bash, depuis la racine du repo) :
#   ./install.sh

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target="${HOME}/.claude"

mkdir -p "${target}"

for dir in commands agents rules; do
    src="${repo_root}/${dir}"
    dst="${target}/${dir}"
    mkdir -p "${dst}"

    for file in "${src}"/*.md; do
        [ -e "${file}" ] || continue
        name="$(basename "${file}")"
        cp -f "${file}" "${dst}/${name}"
        echo "  ${dir}/${name}"
    done
done

# Hooks are shell scripts (not .md), must stay executable, and the *.test.sh
# files stay in the repo (dev-only). Sync the runtime guards into ~/.claude/hooks.
hooks_src="${repo_root}/hooks"
hooks_dst="${target}/hooks"
if [ -d "${hooks_src}" ]; then
    mkdir -p "${hooks_dst}"
    for file in "${hooks_src}"/*.sh; do
        [ -e "${file}" ] || continue
        name="$(basename "${file}")"
        case "${name}" in *.test.sh) continue ;; esac
        cp -f "${file}" "${hooks_dst}/${name}"
        chmod +x "${hooks_dst}/${name}"
        echo "  hooks/${name}"
    done
fi

echo ""
echo "Done. Files synced to ${target}"
