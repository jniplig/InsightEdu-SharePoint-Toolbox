. "$PSScriptRoot/../orchestrator/bootstrap.ps1" -Environment Prod
Get-PnPTenantSite | ForEach-Object {
  try { Get-PnPSharingLink -WebUrl $_.Url } catch {}
} | Export-Csv ./out/sharing-links.csv -NoTypeInformation
