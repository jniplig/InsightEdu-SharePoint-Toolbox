
# InsightEdu Command Library

This starter pack wraps your most common SharePoint Online / PnP actions into reusable scripts + a profile for fast daily use. Tailored for school deployments (NAS/InsightEdu).

See `docs/commands_extracted.md` for raw commands lifted from your console buffer.

## Usage (quick)
```powershell
# install once
Install-Module PnP.PowerShell -Scope CurrentUser
Install-Module Microsoft.Graph -Scope CurrentUser

# load helpers (per session)
. "$PWD\profile\InsightEdu.Profile.ps1"

# connect
cie -TenantName "<tenant>"      # alias for Connect-InsightEduTenant
cis -SiteUrl "https://<tenant>.sharepoint.com/sites/PE"
```
