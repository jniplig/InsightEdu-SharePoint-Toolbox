# Runbook: Converged Authentication Methods — Pilot Rollout

**Purpose:** Prepare for retirement of legacy MFA/SSPR by piloting the **Authentication Methods policy** with a small group before tenant-wide migration.

**Tenant:** netorgft18192557.onmicrosoft.com  
**Last updated:** 2025-09-13 07:45 UTC

---

## 1) Create a pilot group
- **Name:** `SEC-Pilot-StrongAuth`
- Members: 3–5 IT/staff + 1 student test account
- Exclude: break-glass accounts

## 2) Configure Authentication Methods (Policies) — scope to pilot only
Enable for `SEC-Pilot-StrongAuth`:
- **Microsoft Authenticator:** Enabled; *Require number matching*; disable passwordless phone sign-in unless required.
- **FIDO2 / Passkeys:** Enabled (start with staff/managed devices).
- **Temporary Access Pass (TAP):** Enabled; one-time; 10–60 minutes.
- **SMS/Voice:** Enable as backup for staff (not admins). Consider student device availability.
- **Email (for MFA):** Disabled.
- **Windows Hello for Business:** Enable if using Intune/AAD-joined devices.

## 3) Registration & SSPR via Converged Policy
- **Registration campaign:** Enabled for the pilot; 7–14 day snooze.
- **Reset requirements:** Staff = 2 methods; Students = 1 method (adjust to policy).
- Plan to disable the legacy **Password reset (SSPR)** blade after tenant-wide move.

## 4) Conditional Access alignment
- **Admins (now):** CA policy → Directory roles: Privileged roles; Cloud apps: *All*; Grant: **Authentication strength → Phishing-resistant MFA**; Exclude break-glass.
- **Pilot users (optional):** CA policy requiring **Multifactor authentication** or chosen **auth strength** for SharePoint/Teams.

## 5) Communications & Rollback
- Notify pilot users (setup at **aka.ms/mysecurityinfo**, backup methods, TAP use).
- Rollback: remove group scope from method policies and disable CA pilot policy.

## 6) Verification checklist
- Each pilot user registers 2 methods and signs in to SharePoint/Teams.
- Test password reset at **aka.ms/sspr**.
- Admin role holders meet **Phishing-resistant** strength.

---

## Notes
- This does **not** affect app-only certificate auth used by PnP/CI.
- After pilot success, expand scope to `All users` with exclusions for break-glass and staged groups.
