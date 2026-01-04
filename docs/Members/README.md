# Members

Manage group and project membership including access levels and permissions.

## Overview

Membership management is essential for controlling access to GitLab resources. These cmdlets let you add, remove, and modify members at both the group and project level, with support for inherited membership and access level filtering.

## Examples

```powershell
# Get members of a group
Get-GitlabGroupMember -GroupId 'mygroup'

# Get all members including inherited
Get-GitlabGroupMember -GroupId 'mygroup' -IncludeInherited

# Get members with minimum Maintainer access
Get-GitlabGroupMember -GroupId 'mygroup' -MinAccessLevel Maintainer

# Add a member to a group
Add-GitlabGroupMember -GroupId 'mygroup' -UserId 'john.doe' -AccessLevel 'Developer'

# Get a user's memberships across all groups/projects
Get-GitlabUserMembership -UserId 'john.doe'

# Change a member's access level
Set-GitlabGroupMember -GroupId 'mygroup' -UserId 123 -AccessLevel 'Maintainer'
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Add-GitlabGroupMember](Members/Add-GitlabGroupMember.md) | Adds a member to a group |
| [Add-GitlabProjectMember](Members/Add-GitlabProjectMember.md) | Adds a member to a project |
| [Add-GitlabUserMembership](Members/Add-GitlabUserMembership.md) | Adds a user to multiple resources |
| [Get-GitlabGroupMember](Members/Get-GitlabGroupMember.md) | Gets group members |
| [Get-GitlabMemberAccessLevel](Members/Get-GitlabMemberAccessLevel.md) | Gets access level values |
| [Get-GitlabMembershipSortKey](Members/Get-GitlabMembershipSortKey.md) | Gets membership sort options |
| [Get-GitlabProjectMember](Members/Get-GitlabProjectMember.md) | Gets project members |
| [Get-GitlabUserMembership](Members/Get-GitlabUserMembership.md) | Gets user's memberships |
| [Remove-GitlabGroupMember](Members/Remove-GitlabGroupMember.md) | Removes a group member |
| [Remove-GitlabProjectMember](Members/Remove-GitlabProjectMember.md) | Removes a project member |
| [Remove-GitlabUserMembership](Members/Remove-GitlabUserMembership.md) | Removes user membership |
| [Set-GitlabGroupMember](Members/Set-GitlabGroupMember.md) | Updates group member access |
| [Set-GitlabProjectMember](Members/Set-GitlabProjectMember.md) | Updates project member access |
| [Update-GitlabUserMembership](Members/Update-GitlabUserMembership.md) | Updates user membership |
