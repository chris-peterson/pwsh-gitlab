# Deployments

View and track deployments to environments.

## Overview

Deployments represent the act of deploying code to an environment. Track deployment history, see what's deployed where, and monitor deployment status.

## Examples

```powershell
# Get deployments for the current project
Get-GitlabDeployment

# Get deployments to production
Get-GitlabDeployment -Environment 'production'

# Get recent deployments for a project
Get-GitlabDeployment -ProjectId 'mygroup/myproject' -MaxPages 3
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabDeployment](Deployments/Get-GitlabDeployment.md) | Retrieves deployment information |
