#!/usr/bin/env bash
# Sync claude-config repo content into ~/.claude/
# Usage (bash / git-bash, depuis la racine du repo) :
#   ./install.sh
#
# Par défaut, chaque fichier est installé par LIEN SYMBOLIQUE : éditer le repo
# met à jour ~/.claude/ instantanément, aucune re-synchro nécessaire.
# Si les liens symboliques ne sont pas supportés, repli automatique sur la COPIE.

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target="${HOME}/.claude"

mkdir -p "${target}"

link_or_copy() {
    local src="$1" dst="$2" name="$3"
    rm -f "${dst}"
    if ln -s "${src}" "${dst}" 2>/dev/null; then
        echo "  link  ${name}"
    else
        cp -f "${src}" "${dst}"
        echo "  copy  ${name}"
    fi
}

for dir in commands agents rules; do
    src="${repo_root}/${dir}"
    dst="${target}/${dir}"
    mkdir -p "${dst}"

    for file in "${src}"/*.md; do
        [ -e "${file}" ] || continue
        name="$(basename "${file}")"
        link_or_copy "${file}" "${dst}/${name}" "${dir}/${name}"
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
        chmod +x "${file}"
        link_or_copy "${file}" "${hooks_dst}/${name}" "hooks/${name}"
    done
fi

echo ""
echo "Done. Files synced to ${target}"
