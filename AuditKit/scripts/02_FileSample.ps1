param(
  [Parameter(Mandatory=$true)][string]$SitesCsv,
  [Parameter()][int]$TopN = 500,
  [Parameter()][string]$OutDir = "./output",
  [Parameter()][string[]]$ExcludeUrlPatterns = @()
)
$ErrorActionPreference = "Stop"
if (!(Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }
$sites = Import-Csv $SitesCsv
function Skip-Url($url, $patterns){
  foreach($p in $patterns){ if ($url -like "*$p*") { return $true } }
  return $false
}
function Get-Depth([string]$serverRel){ return ($serverRel -split '/').Count }
foreach($s in $sites){
  $url = $s.Url
  if (Skip-Url $url $ExcludeUrlPatterns) { continue }
  try{
    Connect-PnPOnline -Url $url -Interactive
    $libs = Get-PnPList | Where-Object { $_.BaseTemplate -eq 101 -and -not $_.Hidden }
    foreach($lib in $libs){
      $items = Get-PnPListItem -List $lib -PageSize 2000 -ScriptBlock { param($items) $items }
      $files = $items | Where-Object { $_.FileSystemObjectType -eq "File" } | ForEach-Object {
        $f = $_.FieldValues
        [PSCustomObject]@{
          SiteUrl=$url
          Library=$lib.Title
          ServerRelativeUrl=$f.FileRef
          Name=$f.FileLeafRef
          Ext=([System.IO.Path]::GetExtension($f.FileLeafRef)).ToLower()
          SizeMB=[math]::Round($f.SMTotalFileStreamSize/1MB,2)
          Modified=$f.Modified
          Created=$f.Created
          Depth=(Get-Depth $f.FileRef)
        }
      }
      if ($files.Count -eq 0) { continue }
      $files | Sort-Object SizeMB -Descending | Select-Object -First $TopN |
        Export-Csv -Append -NoTypeInformation (Join-Path $OutDir "FileSample.csv")
      $files | Sort-Object Depth -Descending | Select-Object -First $TopN |
        Export-Csv -Append -NoTypeInformation (Join-Path $OutDir "FileSample.csv")
      $files | Sort-Object Modified | Select-Object -First $TopN |
        Export-Csv -Append -NoTypeInformation (Join-Path $OutDir "FileSample.csv")
      $files | Group-Object Ext | ForEach-Object {
        [PSCustomObject]@{
          SiteUrl=$url; Library=$lib.Title; Ext=$_.Name;
          Count=$_.Count; SizeMB=([math]::Round(($_.Group | Measure-Object SizeMB -Sum).Sum,2))
        }
      } | Export-Csv -Append -NoTypeInformation (Join-Path $OutDir "FileTypeProfile.csv")
    }
  } catch { Write-Warning "Files failed on $url : $($_.Exception.Message)" }
}
