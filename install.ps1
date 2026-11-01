[CmdletBinding()]
param(
    [switch]$Force,
    [switch]$Global,
    [string]$TargetDir
)

$ErrorActionPreference = 'Stop'

$sourceAgents = Join-Path $PSScriptRoot '.agents\agents'
if (-not (Test-Path -LiteralPath $sourceAgents -PathType Container)) {
    throw "Cannot find agent package folder: $sourceAgents. Extract the ZIP fully before running the installer."
}

if ($Global) {
    $destinationAgents = Join-Path $HOME '.gemini\config\agents'
} elseif ($TargetDir) {
    $destinationAgents = Join-Path (Resolve-Path -LiteralPath $TargetDir).Path '.agents\agents'
} else {
    $destinationAgents = Join-Path (Get-Location).Path '.agents\agents'
}

if ((Resolve-Path -LiteralPath $sourceAgents).Path -eq (New-Item -ItemType Directory -Path $destinationAgents -Force).FullName) {
    Write-Host "Source and destination are identical ($destinationAgents); nothing to copy." -ForegroundColor Yellow
    return
}

$agentDirs = Get-ChildItem -LiteralPath $sourceAgents -Directory
if ($agentDirs.Count -eq 0) {
    throw "No agent directories found in $sourceAgents."
}

if (-not $Force) {
    $existing = @($agentDirs.Name | Where-Object { Test-Path -LiteralPath (Join-Path $destinationAgents $_) })
    if ($existing.Count -gt 0) {
        throw "These agent folders already exist under ${destinationAgents}: $($existing -join ', '). Re-run with -Force to overwrite, or back them up first."
    }
}

foreach ($dir in $agentDirs) {
    $dest = Join-Path $destinationAgents $dir.Name
    if (Test-Path -LiteralPath $dest) {
        Remove-Item -LiteralPath $dest -Recurse -Force
    }
    Copy-Item -LiteralPath $dir.FullName -Destination $dest -Recurse -Force
}

Write-Host "Installed $($agentDirs.Count) agents ($($agentDirs.Name -join ', ')) into:" -ForegroundColor Green
Write-Host $destinationAgents
Write-Host 'Next: run agy, choose Claude or Gemini 4 Argon with /model, set /effort low, then select claude-argon-supervisor with /agents.'
