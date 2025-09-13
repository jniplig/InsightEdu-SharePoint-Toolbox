## InsightEdu Tenant — Known-Good Values (pinned)

- **App (client) ID:** 7e17c5ea-493f-4654-a5b5-dd94419ba15d
- **Tenant domain (use this in -Tenant):** 
etorgft18192557.onmicrosoft.com
- **SharePoint Admin URL:** https://netorgft18192557-admin.sharepoint.com
- **PFX path (local/CI):** C:\InsightEdu\pnp-cert\InsightEdu-PnP-Orchestrator.pfx  
  *(Password kept locally & in GitHub environment secrets; never commit it.)*

**Known-good connect snippet**
`powershell
7e17c5ea-493f-4654-a5b5-dd94419ba15d    = "7e17c5ea-493f-4654-a5b5-dd94419ba15d"
netorgft18192557.onmicrosoft.com   = "netorgft18192557.onmicrosoft.com"         # domain or GUID, NOT a URL
C:\InsightEdu\pnp-cert\InsightEdu-PnP-Orchestrator.pfx      = "C:\InsightEdu\pnp-cert\InsightEdu-PnP-Orchestrator.pfx"
https://netorgft18192557-admin.sharepoint.com = "https://netorgft18192557-admin.sharepoint.com"
System.Security.SecureString  = Read-Host "PnP cert password" -AsSecureString

Connect-PnPOnline -Url https://netorgft18192557-admin.sharepoint.com -Tenant netorgft18192557.onmicrosoft.com -ClientId 7e17c5ea-493f-4654-a5b5-dd94419ba15d 
  -CertificatePath C:\InsightEdu\pnp-cert\InsightEdu-PnP-Orchestrator.pfx -CertificatePassword System.Security.SecureString
Get-PnPTenantSite | Select -First 3 Url, Title
Common errors & fixes

AADSTS700016 (app not found): App is in a different tenant or admin consent missing. Ensure app + consent are in netorgft18192557.onmicrosoft.com and re-grant Graph (Sites.ReadWrite.All, TermStore.ReadWrite.All, Group.ReadWrite.All, User.Read.All) + SharePoint (Sites.FullControl.All) Application permissions.

“The authority must be a well-formed URI”: -Tenant must be domain or GUID only (no https://). Check spelling.

“Specified method is not supported” / legacy prompts: Use PowerShell 7 with PnP.PowerShell and app-only cert auth. Do not use Register-PnPManagementShellAccess.
