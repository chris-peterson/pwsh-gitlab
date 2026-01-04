# PersonalAccessTokens

Manage personal access tokens for GitLab authentication.

## Overview

Personal access tokens (PATs) authenticate as a specific user and provide access based on the scopes you define. They're used for API access, Git operations over HTTPS, and any automation that requires user-level permissions.

## Examples

```powershell
# Get your personal access tokens
Get-GitlabPersonalAccessToken

# Create a new personal access token (admin only)
New-GitlabPersonalAccessToken -UserId 123 -Name 'API Access' -Scope 'api', 'read_user'

# Rotate an expiring token
Invoke-GitlabPersonalAccessTokenRotation -TokenId 456

# Revoke a token
Revoke-GitlabPersonalAccessToken -TokenId 456
```

> **Note:** Creating tokens for other users requires admin permissions.

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabPersonalAccessToken](PersonalAccessTokens/Get-GitlabPersonalAccessToken.md) | Gets personal access tokens |
| [Invoke-GitlabPersonalAccessTokenRotation](PersonalAccessTokens/Invoke-GitlabPersonalAccessTokenRotation.md) | Rotates a token |
| [New-GitlabPersonalAccessToken](PersonalAccessTokens/New-GitlabPersonalAccessToken.md) | Creates a new token |
| [Revoke-GitlabPersonalAccessToken](PersonalAccessTokens/Revoke-GitlabPersonalAccessToken.md) | Revokes a token |
