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
        New-Item -ItemType SymbolicLink -Path $dst -Target $src -ErrorAction Stop | Out-Null
        Write-Host "  link  $name"
    } catch {
        Copy-Item -Path $src -Destination $dst -Force
        Write-Host "  copy  $name"
    }
}

$dirs = @("commands", "agents", "rules")

foreach ($dir in $dirs) {
    $src = Join-Path $repoRoot $dir
    $dst = Join-Path $target $dir

    if (-not (Test-Path $dst)) {
        New-Item -ItemType Directory -Path $dst | Out-Null
    }

    Get-ChildItem -Path $src -Filter *.md -File | ForEach-Object {
        Install-File $_.FullName (Join-Path $dst $_.Name) "$dir/$($_.Name)"
    }
}

# Hooks are shell scripts (not .md); the *.test.sh files stay in the repo
# (dev-only). Sync the runtime guards into ~/.claude/hooks.
$hooksSrc = Join-Path $repoRoot "hooks"
$hooksDst = Join-Path $target "hooks"
if (Test-Path $hooksSrc) {
    if (-not (Test-Path $hooksDst)) {
        New-Item -ItemType Directory -Path $hooksDst | Out-Null
    }
    Get-ChildItem -Path $hooksSrc -Filter *.sh -File |
        Where-Object { $_.Name -notlike "*.test.sh" } |
        ForEach-Object {
            Install-File $_.FullName (Join-Path $hooksDst $_.Name) "hooks/$($_.Name)"
        }
}

Write-Host ""
Write-Host "Done. Files synced to $target"
