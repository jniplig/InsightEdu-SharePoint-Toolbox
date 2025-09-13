# InsightEdu SharePoint Toolbox

A single, organized package to **deploy, manage, audit, and document** SharePoint Online for schools. Built for Dev/Test/Prod with **no direct changes in Prod**.

## Highlights
- **Orchestrator**: PowerShell + JSON-driven taxonomy, site columns, and content types.
- **PnP Templates**: Hub + Department + Trips site scaffolds.
- **Flows (Power Automate)**: Managed solutions and flow templates (RFQ Approval, Risk Assessment Review).
- **Audit Scripts**: Permissions, sharing links, storage usage, hub associations.
- **Docs**: Governance, Managed Metadata Strategy, ITIL-aligned ops, education patterns.

## Getting Started

```bash
# 1) Clone and enter
git clone <your-repo-url>.git
cd insightedu-sharepoint-toolbox

# 2) Copy and edit environment config (do NOT commit the real file)
cp orchestrator/env.config.example.json orchestrator/env.config.json

# 3) Provision Dev (interactive login)
pwsh -File orchestrator/provision.ps1 -Verbose
```

### Entra App (for CI)
- Create an Entra App with permissions: `Sites.ReadWrite.All`, `Group.ReadWrite.All`, `TermStore.ReadWrite.All` (Application).
- Upload a certificate; store secrets in GitHub (see `/.github/workflows` for variable names).
- Connect with `Connect-PnPOnline -Url <admin-url> -ClientId <id> -Tenant <tenant> -CertificatePath/Thumbprint`.

## Repo Layout
- `/orchestrator` – bootstrap/provision/update/teardown + JSON config
- `/pnp` – template files (`.pnp`), or XML + assets used to build them
- `/audit` – reporting scripts
- `/flows` – managed solutions, connector Swagger, flow JSON templates
- `/spfx` – webparts/extensions (optional)
- `/powerbi` – datasets/reports
- `/docs` – governance/runbooks/patterns/checklists
- `/templates` – list/library schemas, role profiles, RACI

## License
MIT
