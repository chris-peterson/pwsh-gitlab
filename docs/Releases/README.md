# Releases

View project releases and release information.

## Overview

Releases mark specific points in your project's history with associated artifacts, changelogs, and assets. These cmdlets let you retrieve release information from your projects.

## Examples

```powershell
# Get all releases for the current project
Get-GitlabRelease

# Get releases for a specific project
Get-GitlabRelease -ProjectId 'mygroup/myproject'

# Get the latest release
Get-GitlabRelease | Select-Object -First 1
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabRelease](Releases/Get-GitlabRelease.md) | Retrieves project releases |
