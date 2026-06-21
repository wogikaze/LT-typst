$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $Root

foreach ($target in @("_template", "wasm-lt", "discord-bot", "uiua")) {
  $src = Join-Path $target "$target.typ"
  if (Test-Path $src) {
    & (Join-Path $Root "scripts/build.ps1") $target
  }
}
