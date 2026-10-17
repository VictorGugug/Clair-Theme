#Requires -Version 5.1
param([switch]$FullRestore)

$ErrorActionPreference = "Stop"
$ThemeName = "Clair"
$dest = Join-Path $env:APPDATA "spicetify\Themes\$ThemeName"

if (-not (Get-Command spicetify -ErrorAction SilentlyContinue)) {
  Write-Host "Spicetify is not installed." -ForegroundColor Yellow
  exit 1
}

if (Test-Path (Join-Path $env:APPDATA "spicetify\Themes\marketplace")) {
  spicetify config current_theme marketplace inject_theme_js 1 | Out-Null
} else {
  $config = (spicetify -c).Trim()
  (Get-Content -LiteralPath $config) -replace '^(current_theme\s*=).*$', '$1' | Set-Content -LiteralPath $config -Encoding UTF8
  spicetify config inject_theme_js 0 | Out-Null
}

if (Test-Path $dest) {
  Remove-Item -Recurse -Force -LiteralPath $dest
}

if ($FullRestore) {
  spicetify restore backup apply
} else {
  spicetify apply
}

Write-Host "$ThemeName uninstalled." -ForegroundColor Cyan
