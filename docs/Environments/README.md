# Environments

Manage deployment environments for your projects.

## Overview

Environments represent your deployment targets (production, staging, review apps, etc.). These cmdlets let you view environment status, stop running deployments, and clean up unused environments.

## Examples

```powershell
# Get all environments for a project
Get-GitlabEnvironment -ProjectId 'mygroup/myproject'

# Get the production environment
Get-GitlabEnvironment -Name 'production'

# Search for review environments
Get-GitlabEnvironment -Search 'review' -State 'stopped'

# Stop a running environment
Stop-GitlabEnvironment -ProjectId 'mygroup/myproject' -EnvironmentId 123

# Remove an environment
Remove-GitlabEnvironment -ProjectId 'mygroup/myproject' -EnvironmentId 123
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabEnvironment](Environments/Get-GitlabEnvironment.md) | Gets project environments |
| [Remove-GitlabEnvironment](Environments/Remove-GitlabEnvironment.md) | Deletes an environment |
| [Stop-GitlabEnvironment](Environments/Stop-GitlabEnvironment.md) | Stops a running environment |

## Aliases

- `envs` → `Get-GitlabEnvironment`
