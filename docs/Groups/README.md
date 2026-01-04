# Groups

Manage GitLab groups including hierarchy, variables, and sharing.

## Overview

Groups in GitLab organize projects and manage permissions at scale. These cmdlets let you create, modify, and organize groups, manage CI/CD variables at the group level, and share groups with other groups for cross-team collaboration.

## Examples

```powershell
# Get a specific group
Get-GitlabGroup -GroupId 'my-group'

# Get subgroups recursively
Get-GitlabGroup -ParentGroupId 'my-org' -Recurse

# Get the group from current directory context
Get-GitlabGroup -GroupId '.'

# Create a new group
New-GitlabGroup -Name 'my-new-group' -Path 'my-new-group' -ParentGroupId 'parent-group'

# Clone all projects in a group
Copy-GitlabGroupToLocalFileSystem -GroupId 'my-group'
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Copy-GitlabGroupToLocalFileSystem](Groups/Copy-GitlabGroupToLocalFileSystem.md) | Clones all projects in a group locally |
| [Get-GitlabGroup](Groups/Get-GitlabGroup.md) | Retrieves group information |
| [Get-GitlabGroupVariable](Groups/Get-GitlabGroupVariable.md) | Gets CI/CD variables for a group |
| [Move-GitlabGroup](Groups/Move-GitlabGroup.md) | Moves a group to a new parent |
| [New-GitlabGroup](Groups/New-GitlabGroup.md) | Creates a new group |
| [New-GitlabGroupToGroupShare](Groups/New-GitlabGroupToGroupShare.md) | Shares a group with another group |
| [Remove-GitlabGroup](Groups/Remove-GitlabGroup.md) | Deletes a group |
| [Remove-GitlabGroupToGroupShare](Groups/Remove-GitlabGroupToGroupShare.md) | Removes a group share |
| [Remove-GitlabGroupVariable](Groups/Remove-GitlabGroupVariable.md) | Removes a CI/CD variable |
| [Rename-GitlabGroup](Groups/Rename-GitlabGroup.md) | Renames a group |
| [Set-GitlabGroupVariable](Groups/Set-GitlabGroupVariable.md) | Sets a CI/CD variable |
| [Update-GitlabGroup](Groups/Update-GitlabGroup.md) | Updates group settings |
| [Update-LocalGitlabGroup](Groups/Update-LocalGitlabGroup.md) | Updates local clones of group projects |
