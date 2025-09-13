# Contributing

1. Create a feature branch: `git checkout -b feature/<short-name>`
2. Add/update docs under `/docs` and scripts under `/orchestrator` or `/audit`.
3. Run lint/tests locally:
   - PowerShell: `pwsh -c 'Install-Module PSScriptAnalyzer -Scope CurrentUser; Invoke-ScriptAnalyzer -Path orchestrator -Recurse'`
   - SPFx (if applicable): `npm ci && npm run build`
4. Open a PR against `main` with a clear description and deployment runbook reference.
