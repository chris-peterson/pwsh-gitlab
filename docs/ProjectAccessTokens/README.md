# ProjectAccessTokens

Manage access tokens scoped to GitLab projects.

## Overview

Project access tokens provide programmatic access to a specific project. They're ideal for CI/CD integrations, automation scripts, and service accounts that need project-level access without using personal credentials.

## Examples

```powershell
# Get all tokens for a project
Get-GitlabProjectAccessToken -ProjectId 'mygroup/myproject'

# Create a new project access token
New-GitlabProjectAccessToken -ProjectId 'mygroup/myproject' -Name 'CI Token' -Scope 'api' -AccessLevel 'Developer'

# Rotate an expiring token
Invoke-GitlabProjectAccessTokenRotation -ProjectId 'mygroup/myproject' -TokenId 123

# Revoke a token
Remove-GitlabProjectAccessToken -ProjectId 'mygroup/myproject' -TokenId 123
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabProjectAccessToken](ProjectAccessTokens/Get-GitlabProjectAccessToken.md) | Gets project access tokens |
| [Invoke-GitlabProjectAccessTokenRotation](ProjectAccessTokens/Invoke-GitlabProjectAccessTokenRotation.md) | Rotates a token |
| [New-GitlabProjectAccessToken](ProjectAccessTokens/New-GitlabProjectAccessToken.md) | Creates a new token |
| [Remove-GitlabProjectAccessToken](ProjectAccessTokens/Remove-GitlabProjectAccessToken.md) | Revokes a token |
