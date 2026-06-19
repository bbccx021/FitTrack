<#
  Rebuild the FitTrack web export with a given GitHub Pages base path.

  Usage (from the APP folder, or anywhere):
    .\fittrack-web\rebuild-web.ps1 -Repo fittrack     # -> baseUrl /fittrack
    .\fittrack-web\rebuild-web.ps1 -Repo my-gym       # -> baseUrl /my-gym
    .\fittrack-web\rebuild-web.ps1 -Repo ""           # -> baseUrl /  (user/org page)

  Sets fittrack-app/app.json experiments.baseUrl, runs `expo export -p web`,
  and copies the result into this fittrack-web folder (with .nojekyll + 404.html).
#>
param([Parameter(Mandatory = $true)][string]$Repo)

$ErrorActionPreference = "Stop"
$web = $PSScriptRoot
$app = Join-Path (Split-Path $web -Parent) "fittrack-app"
$appJson = Join-Path $app "app.json"
$baseUrl = if ([string]::IsNullOrWhiteSpace($Repo)) { "/" } else { "/$($Repo.Trim('/'))" }

Write-Host "Setting baseUrl = $baseUrl in $appJson"
$json = Get-Content $appJson -Raw | ConvertFrom-Json
if (-not $json.expo.experiments) {
  $json.expo | Add-Member -NotePropertyName experiments -NotePropertyValue ([pscustomobject]@{}) -Force
}
$json.expo.experiments | Add-Member -NotePropertyName baseUrl -NotePropertyValue $baseUrl -Force
($json | ConvertTo-Json -Depth 20) | Set-Content $appJson -Encoding utf8

Write-Host "Exporting web build..."
Push-Location $app
try { npx expo export -p web -c } finally { Pop-Location }

Write-Host "Copying dist -> fittrack-web ..."
Get-ChildItem -Force $web | Where-Object { $_.Name -notin @("README.md", "rebuild-web.ps1") } |
  Remove-Item -Recurse -Force
Copy-Item -Recurse -Force (Join-Path $app "dist\*") $web
New-Item -ItemType File -Force -Path (Join-Path $web ".nojekyll") | Out-Null
Copy-Item -Force (Join-Path $web "index.html") (Join-Path $web "404.html")

Write-Host "Done. Serve at https://<user>.github.io$baseUrl/"
