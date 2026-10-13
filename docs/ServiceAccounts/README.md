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

# Run commands as a group service account, so what they create belongs to it
Set-GitlabServiceAccount -GroupId 'my-group' -Username 'deploy-bot' |
    Use-GitlabToken { New-GitlabPipelineTrigger -ProjectId 'my-group/my-project' 'deploy' }

# Create a personal access token for a group service account
Get-GitlabServiceAccount -GroupId 'my-group' -ServiceAccountId 123 |
    New-GitlabServiceAccountPersonalAccessToken -Name 'ci-reader' -Scope read_api -ExpiresAt (Get-Date).AddDays(30)

# Remove a service account
Remove-GitlabServiceAccount -ServiceAccountId 123
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabServiceAccount](ServiceAccounts/Get-GitlabServiceAccount.md) | Gets service accounts |
| [New-GitlabServiceAccount](ServiceAccounts/New-GitlabServiceAccount.md) | Creates a service account |
| [New-GitlabServiceAccountPersonalAccessToken](ServiceAccounts/New-GitlabServiceAccountPersonalAccessToken.md) | Creates a personal access token for a group service account |
| [Remove-GitlabServiceAccount](ServiceAccounts/Remove-GitlabServiceAccount.md) | Deletes a service account |
| [Remove-GitlabServiceAccountPersonalAccessToken](ServiceAccounts/Remove-GitlabServiceAccountPersonalAccessToken.md) | Revokes a group service account's personal access token |
| [Set-GitlabServiceAccount](ServiceAccounts/Set-GitlabServiceAccount.md) | Creates a group service account, or returns the one with that username |
| [Update-GitlabServiceAccount](ServiceAccounts/Update-GitlabServiceAccount.md) | Updates a service account |
