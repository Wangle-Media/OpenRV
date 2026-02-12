param(
  [string]$StageDir = "$PSScriptRoot\..\_build\stage\app",
  [string]$OutFile = "$PSScriptRoot\..\dist\OpenRV-portable.zip"
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $StageDir)) {
  throw "Stage directory not found: $StageDir (build first)"
}

$distDir = Split-Path -Parent $OutFile
New-Item -ItemType Directory -Force -Path $distDir | Out-Null

if (Test-Path $OutFile) { Remove-Item -Force $OutFile }

Compress-Archive -Path (Join-Path $StageDir '*') -DestinationPath $OutFile
Write-Host "Wrote: $OutFile" -ForegroundColor Green
