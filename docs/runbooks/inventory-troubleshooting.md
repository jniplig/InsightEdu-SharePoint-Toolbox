# Runbook: SharePoint Inventory (PnP app-only) — Known‑good patterns & troubleshooting

**Tenant:** `netorgft18192557.onmicrosoft.com`  
**App (client) ID:** `7e17c5ea-493f-4654-a5b5-dd94419ba15d`  
**Last updated:** 2025-09-13 07:57 UTC

---

## What went wrong (symptoms we saw)
- Per‑site scan returned `-` values for Lists/Libraries/UniqueCT.  
- Errors when filtering sites: *“The term '-and' is not recognized …”* (multiline predicate).  
- *AADSTS700016: Application not found* → app registered/consented in a **different tenant**.  
- *“The authority (including the tenant ID) must be in a well‑formed URI format”* → `-Tenant` passed a URL instead of **domain/GUID**.

## Known‑good connect values (pin for this tenant)
```powershell
$AppId    = "7e17c5ea-493f-4654-a5b5-dd94419ba15d"
$Tenant   = "netorgft18192557.onmicrosoft.com"      # domain or GUID (not a URL)
$Pfx      = "C:\InsightEdu\pnp-cert\InsightEdu-PnP-Orchestrator.pfx"
$AdminUrl = "https://netorgft18192557-admin.sharepoint.com"
$certPwd  = Read-Host "PnP cert password" -AsSecureString
Connect-PnPOnline -Url $AdminUrl -Tenant $Tenant -ClientId $AppId `
  -CertificatePath $Pfx -CertificatePassword $certPwd
```

## Correct site filter (avoid multiline `-and`)
```powershell
$sites = Import-Csv ".\audit\out\sites.csv" |
  Where-Object { ($_.Url -match '^https://netorgft18192557\.sharepoint\.com($|/sites/)') -and ($_.Url -notmatch '/search') } |
  Select-Object -ExpandProperty Url
```

## Robust per‑site scanner (captures errors per site)
```powershell
function Get-IEduSiteComplexity {
  param([string]$Url)
  try {
    $ErrorActionPreference = 'Stop'
    Connect-PnPOnline -Url $Url -Tenant $Tenant -ClientId $AppId -CertificatePath $Pfx -CertificatePassword $certPwd
    $lists = Get-PnPList -Includes BaseType
    $cts   = Get-PnPContentType
    $classic = 0
    try {
      $classic = (Get-PnPList -Identity "Site Pages","Pages" -ErrorAction Stop |
                  Get-PnPListItem -PageSize 200 |
                  Where-Object { $_.FieldValues["ClientSideApplicationId"] -eq $null }).Count
    } catch { $classic = 0 }
    [pscustomobject]@{ SiteUrl=$Url; Lists=$lists.Count; Libraries=($lists|? {$_.BaseType -eq "DocumentLibrary"}).Count;
      UniqueCT=($cts|? {$_.StringId -notlike "0x0101*" -and $_.StringId -notlike "0x0120*"}).Count;
      ClassicPages=$classic; Error="" }
  } catch { [pscustomobject]@{ SiteUrl=$Url; Lists=$null; Libraries=$null; UniqueCT=$null; ClassicPages=$null; Error=$_.Exception.Message } }
}
$sites  = Import-Csv ".\audit\out\sites.csv" | Where-Object { ($_.Url -match '^https://netorgft18192557\.sharepoint\.com($|/sites/)') -and ($_.Url -notmatch '/search') } | Select-Object -Expand Url
$result = $sites | ForEach-Object { Get-IEduSiteComplexity $_ }
$result | Export-Csv ".\audit\out\site-complexity.csv" -NoTypeInformation
```

## Pre‑scan checklist (to prevent repeat issues)
- Entra app lives in **netorgft18192557.onmicrosoft.com** and has **admin consent** for:  
  - Graph (Application): `Sites.ReadWrite.All`, `TermStore.ReadWrite.All`, `Group.ReadWrite.All`, `User.Read.All`  
  - SharePoint (Application): `Sites.FullControl.All`
- Use **PowerShell 7** and `PnP.PowerShell` (latest).
- Use **app‑only cert auth** (no interactive `-UseWebLogin`, no deprecated `Register-PnPManagementShellAccess`).
- For inventory, **connect to each site URL** when reading lists/CTs (admin URL alone is not enough).

## One‑site sanity test (ED‑PE example)
```powershell
$TestSite = "https://netorgft18192557.sharepoint.com/sites/ed-pe"
Connect-PnPOnline -Url $TestSite -Tenant $Tenant -ClientId $AppId -CertificatePath $Pfx -CertificatePassword $certPwd
Get-PnPWeb | Select Url, Title
(Get-PnPList -Includes BaseType | Measure-Object).Count
(Get-PnPContentType | Select -First 5 Name, StringId)
```

## Decision rubric (use with site‑complexity.csv)
- **Clean Slate** favoured if per target site: Storage < **5,000 MB**, `UniqueCT` < **5**, `ClassicPages` ≈ **0**, minimal external links.
- Else **Retrofit** in place (associate to hub, apply templates, backfill metadata).

---

> Save location: `docs/runbooks/inventory-troubleshooting.md` in the repo.
