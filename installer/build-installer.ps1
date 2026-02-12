param(
  [string]$IssPath = "$PSScriptRoot\OpenRV.iss"
)

$ErrorActionPreference = 'Stop'

$possibleIscc = @(
  "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
  "$env:ProgramFiles\Inno Setup 6\ISCC.exe"
)

$iscc = $possibleIscc | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $iscc) {
  throw "ISCC.exe not found. Install Inno Setup 6, then re-run. Looked in: $($possibleIscc -join '; ')"
}

if (-not (Test-Path $IssPath)) {
  throw "Inno Setup script not found: $IssPath"
}

# Ensure output folder exists (matches OutputDir in the .iss)
$distDir = Join-Path $PSScriptRoot '..\dist'
New-Item -ItemType Directory -Force -Path $distDir | Out-Null

& $iscc $IssPath
Write-Host "Built installer into: $distDir" -ForegroundColor Green
