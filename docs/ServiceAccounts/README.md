# ServiceAccounts

Manage service accounts for automation and CI/CD.

## Overview

Service accounts are bot users designed for automation tasks. They provide a way to authenticate automated processes without using personal accounts, improving security and audit trails.

## Examples

```powershell
# Get service accounts
Get-GitlabServiceAccount

# Create a new service account
New-GitlabServiceAccount -Name 'deploy-bot' -Username 'deploy-bot'

# Update a service account
Update-GitlabServiceAccount -ServiceAccountId 123 -Name 'updated-name'

# Remove a service account
Remove-GitlabServiceAccount -ServiceAccountId 123
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabServiceAccount](ServiceAccounts/Get-GitlabServiceAccount.md) | Gets service accounts |
| [New-GitlabServiceAccount](ServiceAccounts/New-GitlabServiceAccount.md) | Creates a service account |
| [Remove-GitlabServiceAccount](ServiceAccounts/Remove-GitlabServiceAccount.md) | Deletes a service account |
| [Update-GitlabServiceAccount](ServiceAccounts/Update-GitlabServiceAccount.md) | Updates a service account |
