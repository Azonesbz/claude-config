# Sync claude-config repo content into ~/.claude/
# Usage (PowerShell, depuis la racine du repo) :
#   .\install.ps1

$ErrorActionPreference = "Stop"

$repoRoot = $PSScriptRoot
$target = Join-Path $env:USERPROFILE ".claude"

if (-not (Test-Path $target)) {
    New-Item -ItemType Directory -Path $target | Out-Null
}

$dirs = @("commands", "agents", "rules")

foreach ($dir in $dirs) {
    $src = Join-Path $repoRoot $dir
    $dst = Join-Path $target $dir

    if (-not (Test-Path $dst)) {
        New-Item -ItemType Directory -Path $dst | Out-Null
    }

    Get-ChildItem -Path $src -Filter *.md -File | ForEach-Object {
        $dstFile = Join-Path $dst $_.Name
        Copy-Item -Path $_.FullName -Destination $dstFile -Force
        Write-Host "  $dir/$($_.Name)"
    }
}

Write-Host ""
Write-Host "Done. Files synced to $target"
