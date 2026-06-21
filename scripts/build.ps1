param(
  [Parameter(Mandatory = $true, Position = 0)]
  [string]$Target
)

$ErrorActionPreference = "Stop"
$Target = $Target.TrimEnd('/', '\')

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $Root

$Src = Join-Path $Target "$Target.typ"
$OutDir = Join-Path "build" $Target
$Out = Join-Path $OutDir "$Target.pdf"

if (-not (Test-Path $Src)) {
  Write-Error "Source file not found: $Src"
}

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$Typst = Get-Command typst -ErrorAction SilentlyContinue
if (-not $Typst) {
  $Fallback = Join-Path $env:LOCALAPPDATA "Microsoft\WinGet\Packages\Typst.Typst_Microsoft.Winget.Source_8wekyb3d8bbwe\typst-x86_64-pc-windows-msvc\typst.exe"
  if (Test-Path $Fallback) {
    $Typst = $Fallback
  } else {
    Write-Error "typst not found in PATH. Install Typst or add it to PATH."
  }
} else {
  $Typst = $Typst.Source
}

& $Typst compile --root $Root $Src $Out
Write-Host "Wrote $Out"
