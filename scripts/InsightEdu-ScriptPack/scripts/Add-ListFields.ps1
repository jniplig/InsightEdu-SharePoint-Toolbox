[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$SiteUrl,
    [Parameter(Mandatory=$true)][string]$ListTitle,
    [Parameter(Mandatory=$true)][string]$FieldsJson
)
$ErrorActionPreference = 'Stop'
if (-not (Test-Path $FieldsJson)) { throw "Fields JSON not found: $FieldsJson" }
Connect-PnPOnline -Url $SiteUrl -Interactive
$fields = Get-Content -Raw -Path $FieldsJson | ConvertFrom-Json
foreach ($f in $fields) {
    $exists = Get-PnPField -List $ListTitle -Identity $f.InternalName -ErrorAction SilentlyContinue
    if (-not $exists) {
        Add-PnPField -List $ListTitle -DisplayName $f.DisplayName -InternalName $f.InternalName -Type $f.Type -AddToDefaultView:$true -Required:([bool]$f.Required)
        Write-Host "Added field $($f.DisplayName) ($($f.InternalName))" -ForegroundColor Green
    } else {
        Write-Host "Field exists: $($f.InternalName) — skipping" -ForegroundColor Yellow
    }
}