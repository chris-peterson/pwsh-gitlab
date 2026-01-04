# Runners

Manage and monitor CI/CD runners.

## Overview

Runners execute your CI/CD jobs. These cmdlets help you monitor runner status, view job history, manage runner settings, and perform maintenance operations like pausing and removing runners.

## Examples

```powershell
# List all runners
Get-GitlabRunner

# Get online runners with specific tags
Get-GitlabRunner -Status 'online' -Tags 'docker', 'linux' -FetchDetails

# Get runner statistics
Get-GitlabRunnerStats

# View jobs run by a specific runner
Get-GitlabRunnerJob -RunnerId 123

# Pause a runner for maintenance
Suspend-GitlabRunner -RunnerId 123

# Resume a paused runner
Resume-GitlabRunner -RunnerId 123
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabRunner](Runners/Get-GitlabRunner.md) | Gets runner information |
| [Get-GitlabRunnerJob](Runners/Get-GitlabRunnerJob.md) | Gets jobs executed by a runner |
| [Get-GitlabRunnerStats](Runners/Get-GitlabRunnerStats.md) | Gets runner statistics |
| [Remove-GitlabRunner](Runners/Remove-GitlabRunner.md) | Deletes a runner |
| [Resume-GitlabRunner](Runners/Resume-GitlabRunner.md) | Resumes a paused runner |
| [Suspend-GitlabRunner](Runners/Suspend-GitlabRunner.md) | Pauses a runner |
| [Update-GitlabRunner](Runners/Update-GitlabRunner.md) | Updates runner configuration |
