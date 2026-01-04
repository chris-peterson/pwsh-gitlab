# Branches

Manage repository branches including creation, deletion, and protection rules.

## Overview

Branch management is fundamental to Git workflows. These cmdlets allow you to list, create, and delete branches, as well as configure branch protection rules to enforce code review policies and prevent direct pushes to critical branches.

## Examples

```powershell
# List all branches in the current project
Get-GitlabBranch

# Search for branches containing 'feature'
Get-GitlabBranch -Search 'feature'

# Create a new branch from main
New-GitlabBranch -Name 'feature/my-feature' -Ref 'main'

# Protect the main branch
Protect-GitlabBranch -Branch 'main' -PushAccessLevel 'maintainer' -MergeAccessLevel 'developer'
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabBranch](Branches/Get-GitlabBranch.md) | Gets branches from a project repository |
| [Get-GitlabProtectedBranch](Branches/Get-GitlabProtectedBranch.md) | Gets protected branch configurations |
| [New-GitlabBranch](Branches/New-GitlabBranch.md) | Creates a new branch |
| [Protect-GitlabBranch](Branches/Protect-GitlabBranch.md) | Configures branch protection rules |
| [Remove-GitlabBranch](Branches/Remove-GitlabBranch.md) | Deletes a branch |
| [UnProtect-GitlabBranch](Branches/UnProtect-GitlabBranch.md) | Removes branch protection |
