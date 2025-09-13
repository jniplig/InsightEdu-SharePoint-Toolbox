# Runbook: PnP Entra App Registration & Connect (post-2024)

**Purpose:** Standardize on **app-only certificate auth** with a single-tenant Entra app for PnP.PowerShell to avoid interactive login issues.

**Applies to:** SharePoint Online (Microsoft 365), PowerShell 7.x, PnP.PowerShell (latest).  
**Last updated:** 2025-09-13 07:11 UTC

---

## Prerequisites
- Entra **Global Admin** (or Privileged Role Admin) in the target tenant.
- PowerShell **7.x** installed.
- `PnP.PowerShell` module installed/updated in PS7:
  ```powershell
  Install-Module PnP.PowerShell -Scope CurrentUser -Force
  Update-Module  PnP.PowerShell -Force
  ```

---

## Step 1 — Create a certificate (local)
Run in **PowerShell 7 (x64)**:

```powershell
$certFolder = "$env:USERPROFILE\InsightEdu\pnp-cert"
New-Item -ItemType Directory -Path $certFolder -ErrorAction SilentlyContinue | Out-Null
$certPwd = Read-Host "Enter a password for the PnP certificate" -AsSecureString

$cert = New-SelfSignedCertificate `
  -Subject "CN=InsightEdu PnP Orchestrator" `
  -CertStoreLocation "Cert:\CurrentUser\My" `
  -KeyExportPolicy Exportable -KeySpec Signature `
  -KeyAlgorithm RSA -KeyLength 2048 `
  -NotAfter (Get-Date).AddYears(2)

Export-Certificate -Cert ("Cert:\CurrentUser\My\" + $cert.Thumbprint) `
  -FilePath (Join-Path $certFolder "InsightEdu-PnP-Orchestrator.cer") | Out-Null

Export-PfxCertificate -Cert ("Cert:\CurrentUser\My\" + $cert.Thumbprint) `
  -FilePath (Join-Path $certFolder "InsightEdu-PnP-Orchestrator.pfx") `
  -Password $certPwd | Out-Null
```

**Outputs:**
- `InsightEdu-PnP-Orchestrator.cer` (upload to Entra)
- `InsightEdu-PnP-Orchestrator.pfx` (used locally / CI with password)

---

## Step 2 — Register the Entra application
In **entra.microsoft.com** (ensure the **InsightEdu** tenant is selected):

1. **App registrations → New registration**  
   - Name: `InsightEdu PnP Orchestrator`  
   - Supported account types: **Single tenant**  
   - Click **Register** and copy the **Application (client) ID**.
2. **Certificates & secrets → Certificates → Upload certificate** → select the `.cer` from Step 1.
3. **API permissions → Add a permission**  
   - **Microsoft Graph** → **Application permissions**:  
     `Sites.ReadWrite.All`, `TermStore.ReadWrite.All`, `Group.ReadWrite.All`, `User.Read.All`  
   - **SharePoint** → **Application permissions**:  
     `Sites.FullControl.All`  
   - Click **Grant admin consent** for the tenant and confirm.

> Keep: **App (Client) ID**, **Tenant** (`insightedu.onmicrosoft.com`), and the PFX path/password.

---

## Step 3 — Connect with PnP (certificate auth)
```powershell
$AppId  = "<APP_CLIENT_ID>"               # from Step 2
$Tenant = "insightedu.onmicrosoft.com"
$Pfx    = "$env:USERPROFILE\InsightEdu\pnp-cert\InsightEdu-PnP-Orchestrator.pfx"

Connect-PnPOnline -Url "https://netorgft18192557-admin.sharepoint.com" `
  -Tenant $Tenant -ClientId $AppId `
  -CertificatePath $Pfx -CertificatePassword $certPwd

# Verify
Get-PnPTenantSite | Select -First 3 Url, Title
```

---

## Step 4 — CI/CD in GitHub
1. Convert PFX to base64 for safe storage in GitHub Secrets:
   ```powershell
   [Convert]::ToBase64String([IO.File]::ReadAllBytes($Pfx)) | `
     Out-File -Encoding ascii "$env:USERPROFILE\InsightEdu\pnp-cert\pfx.b64"
   ```
2. In your GitHub repo, create **Environments**: `Dev`, `Test`, `Prod`.
3. Add environment **secrets**:  
   - `PFX_BASE64` → contents of `pfx.b64`  
   - `PFX_PASSWORD` → your certificate password
4. Use `.github/workflows/deploy.yml` to run `orchestrator/provision.ps1` with the above secrets.

---

## Troubleshooting
- **AADSTS700016 / app not found** → App was created/consented in the wrong directory. Switch to the **InsightEdu** tenant and re-grant consent.
- **Insufficient privileges** → You didn’t click **Grant admin consent** or are not Global Admin.
- **Keyset/cert errors** → Use the `.pfx` path shown above; re-enter `$certPwd` in the current session.
- **Mixing auth types** → Avoid combining user interactive auth and app-only in one run; open a fresh PS7 session.

---

## Reusable connect snippet (drop-in)
Save as `orchestrator/connect-dev.ps1`:
```powershell
param([string]$Env = 'Dev', [string]$AppId = '<APP_CLIENT_ID>', [string]$PfxPath = "$env:USERPROFILE\InsightEdu\pnp-cert\InsightEdu-PnP-Orchestrator.pfx")
$certPwd = Read-Host "PnP cert password" -AsSecureString
$cfg = Get-Content "$PSScriptRoot/env.config.json" -Raw | ConvertFrom-Json
$adminUrl = $cfg.$Env.AdminUrl
Connect-PnPOnline -Url $adminUrl -Tenant 'insightedu.onmicrosoft.com' -ClientId $AppId -CertificatePath $PfxPath -CertificatePassword $certPwd
```

---

## Change history
- v1.0 – Initial runbook added (post-2024 PnP auth changes).
