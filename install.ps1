# Sync claude-config repo content into ~/.claude/
# Usage (PowerShell, depuis la racine du repo) :
#   .\install.ps1
#
# Par défaut, chaque fichier est installé par LIEN SYMBOLIQUE : éditer le repo
# met à jour ~/.claude/ instantanément, aucune re-synchro nécessaire.
# Les liens symboliques sous Windows requièrent le "Mode développeur" (Windows 10+)
# ou une session admin. Sinon, repli automatique sur la COPIE (relancer après chaque modif).

$ErrorActionPreference = "Stop"

$repoRoot = $PSScriptRoot
$target = Join-Path $env:USERPROFILE ".claude"

if (-not (Test-Path $target)) {
    New-Item -ItemType Directory -Path $target | Out-Null
}

function Install-File($src, $dst, $name) {
    if (Test-Path $dst) { Remove-Item $dst -Force }
    try {
        New-Item -ItemType SymbolicLink -Path $dst -Target $src -ErrorActio