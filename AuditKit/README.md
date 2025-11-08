# InsightEdu SharePoint AuditKit (PnP.PowerShell)

A lean, repeatable **inventory and governance audit** for SharePoint Online / OneDrive that produces CSVs you can use to design the **Term Store, Content Types, hub model, and site configurations**.

## Outputs (in `/output`)

- `Sites.csv` – all sites (URL, template, owner, storage, last modified, hub flags)
- `Hubs.csv` – hub sites (ID, title, URL)
- `HubConnections.csv` – which sites are attached to which hub
- `Libraries.csv` – lists/libs with key settings (versioning, moderation, unique perms)
- `ContentTypes.csv` – site content types (ID, group, sealed/read-only)
- `Fields.csv` – site columns (internal names, types, required)
- `Permissions.csv` – web/list unique permissions & role bindings
- `FileSample.csv` – top N **largest**, **deepest**, **oldest** files per library
- `FileTypeProfile.csv` – counts and size by extension per library
- `TermStore.csv` – groups, sets, terms (IDs, hierarchy)
- `Findings.md` – template to turn raw data into decisions

## Prerequisites
- PowerShell 7+ (recommended)
- PnP.PowerShell: `Install-Module PnP.PowerShell -Scope CurrentUser`
- SharePoint admin permissions

## Quick start
1. Copy `config.example.json` to `config.json` and edit your values.
2. Run: `pwsh ./scripts/Run-Audit.ps1 -ConfigPath ./config.json`

## Config (`config.json`)
```json
{
  "TenantShortName": "yourtenant",
  "RootUrl": "https://yoursite.sharepoint.com",
  "IncludeOneDriveSites": false,
  "OutDir": "./output",
  "SitesCsv": "./output/Sites.csv",
  "ExcludeUrlPatterns": ["-my.sharepoint.com", "/personal/"],
  "TopN": 500
}
```

## Script order
- `00_TenantInventory.ps1` → sites & hubs
- `01_SiteInventory.ps1` → libraries, content types, fields, permissions
- `02_FileSample.ps1` → size/depth/staleness & filetype profile
- `03_TermStoreExport.ps1` → taxonomy export
- `Run-Audit.ps1` → orchestration

## Next steps
Use outputs to define **term sets, columns, content types, hub plan, and library baseline** (`Working / Published / Archive`).

MIT License.
