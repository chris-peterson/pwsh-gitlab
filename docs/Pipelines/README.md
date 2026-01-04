# Pipelines

Trigger, monitor, and manage CI/CD pipelines.

## Overview

Pipelines are the foundation of GitLab CI/CD, orchestrating builds, tests, and deployments. These cmdlets let you trigger new pipelines, monitor their status, retrieve variables, and manage pipeline lifecycle including cleanup of old pipelines.

## Examples

```powershell
# Get pipelines for the current project
Get-GitlabPipeline

# Get failed pipelines on main branch triggered by you
Get-GitlabPipeline -Ref 'main' -Status 'failed' -Mine

# Trigger a new pipeline on the current branch
New-GitlabPipeline

# Trigger a pipeline with custom variables
New-GitlabPipeline -Ref 'main' -Variables @{DEPLOY_ENV='staging'; DEBUG='true'}

# Get pipeline with downstream/upstream relationships
Get-GitlabPipeline -PipelineId 12345 -FetchDownstream
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabPipeline](Pipelines/Get-GitlabPipeline.md) | Gets pipelines with filtering options |
| [Get-GitlabPipelineBridge](Pipelines/Get-GitlabPipelineBridge.md) | Gets pipeline bridge jobs (triggers) |
| [Get-GitlabPipelineVariable](Pipelines/Get-GitlabPipelineVariable.md) | Gets variables for a pipeline |
| [New-GitlabPipeline](Pipelines/New-GitlabPipeline.md) | Triggers a new pipeline |
| [Remove-GitlabPipeline](Pipelines/Remove-GitlabPipeline.md) | Deletes a pipeline |

## Aliases

- `pipeline` → `Get-GitlabPipeline`
- `pipelines` → `Get-GitlabPipeline`
- `build` → `New-GitlabPipeline`
