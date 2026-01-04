# GroupAccessTokens

Manage access tokens scoped to GitLab groups.

## Overview

Group access tokens provide programmatic access to GitLab resources at the group level. They're ideal for CI/CD integrations, automation scripts, and service accounts that need access to multiple projects within a group.

## Examples

```powershell
# Get all tokens for a group
Get-GitlabGroupAccessToken -GroupId 'my-group'

# Create a new access token
New-GitlabGroupAccessToken -GroupId 'my-group' -Name 'CI Token' -Scope 'api' -AccessLevel 'Developer'

# Create token with multiple scopes and copy to clipboard
New-GitlabGroupAccessToken -GroupId 'my-group' -Name 'Deploy Token' `
    -Scope 'read_repository','write_repository' -AccessLevel 'Maintainer' -CopyToClipboard

# Create token with custom expiration
New-GitlabGroupAccessToken -GroupId 'my-group' -Name 'Short-lived' `
    -Scope 'read_api' -AccessLevel 'Reporter' -ExpiresAt (Get-Date).AddMonths(3)

# Revoke a token
Remove-GitlabGroupAccessToken -GroupId 'my-group' -TokenId 123
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabGroupAccessToken](GroupAccessTokens/Get-GitlabGroupAccessToken.md) | Gets group access tokens |
| [New-GitlabGroupAccessToken](GroupAccessTokens/New-GitlabGroupAccessToken.md) | Creates a new token |
| [Remove-GitlabGroupAccessToken](GroupAccessTokens/Remove-GitlabGroupAccessToken.md) | Revokes a token |
