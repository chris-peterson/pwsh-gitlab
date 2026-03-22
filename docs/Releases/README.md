# Releases

Manage project releases.

## Overview

Releases mark specific points in your project's history with associated artifacts, changelogs, and assets. These cmdlets let you create, view, update, and delete releases for your projects.

## Examples

```powershell
# Get all releases for the current project
Get-GitlabRelease

# Get releases for a specific project
Get-GitlabRelease -ProjectId 'mygroup/myproject'

# Create a new release
New-GitlabRelease -TagName 'v1.0.0' -Name 'Version 1.0' -Description 'Initial release'

# Delete a release
Remove-GitlabRelease -TagName 'v0.1.0'
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabRelease](Releases/Get-GitlabRelease.md) | Retrieves project releases |
| [New-GitlabRelease](Releases/New-GitlabRelease.md) | Creates a new release |
| [Update-GitlabRelease](Releases/Update-GitlabRelease.md) | Updates an existing release |
| [Remove-GitlabRelease](Releases/Remove-GitlabRelease.md) | Deletes a release |
