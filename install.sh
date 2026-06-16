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

echo ""
echo "Done. Files synced to ${target}"
