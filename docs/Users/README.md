# Users

Manage GitLab users including blocking, impersonation, and activity tracking.

## Overview

User management cmdlets allow you to retrieve user information, track user activity, and perform administrative actions like blocking users. Admin impersonation support enables troubleshooting user-specific issues.

## Examples

```powershell
# Get a user by username
Get-GitlabUser -UserId 'john.doe'

# Get the current authenticated user
Get-GitlabUser -Me

# Get all active users
Get-GitlabUser -Active -All

# Get a user's activity
Get-GitlabUserEvent -UserId 'john.doe'

# Block a user (admin)
Block-GitlabUser -UserId 123

# Impersonate a user for debugging (admin)
Start-GitlabUserImpersonation -UserId 'john.doe'
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Block-GitlabUser](Users/Block-GitlabUser.md) | Blocks a user account |
| [Get-GitlabCurrentUser](Users/Get-GitlabCurrentUser.md) | Gets the authenticated user |
| [Get-GitlabUser](Users/Get-GitlabUser.md) | Retrieves user information |
| [Get-GitlabUserEvent](Users/Get-GitlabUserEvent.md) | Gets user activity events |
| [Remove-GitlabUser](Users/Remove-GitlabUser.md) | Deletes a user account |
| [Start-GitlabUserImpersonation](Users/Start-GitlabUserImpersonation.md) | Starts impersonating a user |
| [Stop-GitlabUserImpersonation](Users/Stop-GitlabUserImpersonation.md) | Stops user impersonation |
| [Unblock-GitlabUser](Users/Unblock-GitlabUser.md) | Unblocks a user account |
