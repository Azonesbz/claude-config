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
    if ln -s "${src}" "${dst}" 2>/dev/null; th