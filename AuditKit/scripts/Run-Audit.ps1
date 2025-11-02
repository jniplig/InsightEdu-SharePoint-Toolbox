param(
  [Parameter(Mandatory=$true)][string]$ConfigPath
)
$ErrorActionPreference = "Stop"
if (!(Test-Path $ConfigPath)) { throw "Config not found: $ConfigPath" }
$config = Get-Content $ConfigPath | ConvertFrom-Json
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Split-Path -Parent $here
$outDir = Resolve-Path (Join-Path $root $config.OutDir)
& (Join-Path $here "00_TenantInventory.ps1") -TenantShortName $config.TenantShortName -IncludeOneDriveSites $config.IncludeOneDriveSites -OutDir $outDir
& (Join-Path $here "01_SiteInventory.ps1") -SitesCsv (Join-Path $outDir "Sites.csv") -OutDir $outDir -ExcludeUrlPatterns $config.ExcludeUrlPatterns
& (Join-Path $here "02_FileSample.ps1") -SitesCsv (Join-Path $outDir "Sites.csv") -OutDir $outDir -TopN $config.TopN -ExcludeUrlPatterns $config.ExcludeUrlPatterns
& (Join-Path $here "03_TermStoreExport.ps1") -RootUrl $config.RootUrl -OutDir $outDir
# copy Findings template
$tmpl = Join-Path $root "templates/Findings.md"
$dest = Join-Path $outDir "Findings.md"
if (Test-Path $tmpl -and -not (Test-Path $dest)) { Copy-Item $tmpl $dest }
Write-Host "Audit complete → $outDir"
