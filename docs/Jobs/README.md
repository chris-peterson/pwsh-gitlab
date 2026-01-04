# Jobs

Manage CI/CD jobs including traces, artifacts, and pipeline definitions.

## Overview

Jobs are the building blocks of GitLab CI/CD pipelines. These cmdlets let you retrieve job information, download artifacts, view job logs (traces), validate pipeline configurations, and manually trigger jobs.

## Examples

```powershell
# Get all jobs for a project
Get-GitlabJob -ProjectId 'mygroup/myproject'

# Get jobs from a specific pipeline
Get-GitlabJob -PipelineId 12345

# Get a job with its trace log
Get-GitlabJob -JobId 67890 -IncludeTrace

# Download job artifacts
Get-GitlabJobArtifact -JobId 67890 -OutputPath './artifacts'

# Validate your .gitlab-ci.yml
Test-GitlabPipelineDefinition

# Retry a failed job
Start-GitlabJob -JobId 67890
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabJob](Jobs/Get-GitlabJob.md) | Retrieves CI/CD jobs |
| [Get-GitlabJobArtifact](Jobs/Get-GitlabJobArtifact.md) | Downloads job artifacts |
| [Get-GitlabJobTrace](Jobs/Get-GitlabJobTrace.md) | Gets job log output |
| [Get-GitlabPipelineDefinition](Jobs/Get-GitlabPipelineDefinition.md) | Gets the expanded CI config |
| [Start-GitlabJob](Jobs/Start-GitlabJob.md) | Triggers or retries a job |
| [Start-GitlabJobLogSection](Jobs/Start-GitlabJobLogSection.md) | Starts a collapsible log section |
| [Stop-GitlabJobLogSection](Jobs/Stop-GitlabJobLogSection.md) | Ends a collapsible log section |
| [Test-GitlabPipelineDefinition](Jobs/Test-GitlabPipelineDefinition.md) | Validates CI/CD configuration |
| [Write-GitlabJobTrace](Jobs/Write-GitlabJobTrace.md) | Writes to job log output |

## Aliases

- `job` → `Get-GitlabJob`
- `jobs` → `Get-GitlabJob`
