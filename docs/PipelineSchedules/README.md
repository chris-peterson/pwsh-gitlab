# PipelineSchedules

Schedule pipelines to run automatically on a recurring basis.

## Overview

Pipeline schedules let you run pipelines automatically at specified intervals using cron expressions. Perfect for nightly builds, scheduled deployments, or periodic maintenance tasks.

## Examples

```powershell
# Get all schedules for the current project
Get-GitlabPipelineSchedule

# Create a nightly schedule
New-GitlabPipelineSchedule -Description 'Nightly Build' -Ref 'main' -Cron '0 2 * * *'

# Add a variable to a schedule
New-GitlabPipelineScheduleVariable -ScheduleId 123 -Key 'NIGHTLY' -Value 'true'

# Manually trigger a scheduled pipeline
New-GitlabScheduledPipeline -ScheduleId 123

# Disable a schedule
Disable-GitlabPipelineSchedule -ScheduleId 123

# Re-enable a schedule
Enable-GitlabPipelineSchedule -ScheduleId 123
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Disable-GitlabPipelineSchedule](PipelineSchedules/Disable-GitlabPipelineSchedule.md) | Deactivates a schedule |
| [Enable-GitlabPipelineSchedule](PipelineSchedules/Enable-GitlabPipelineSchedule.md) | Activates a schedule |
| [Get-GitlabPipelineSchedule](PipelineSchedules/Get-GitlabPipelineSchedule.md) | Gets pipeline schedules |
| [Get-GitlabPipelineScheduleVariable](PipelineSchedules/Get-GitlabPipelineScheduleVariable.md) | Gets schedule variables |
| [New-GitlabPipelineSchedule](PipelineSchedules/New-GitlabPipelineSchedule.md) | Creates a new schedule |
| [New-GitlabPipelineScheduleVariable](PipelineSchedules/New-GitlabPipelineScheduleVariable.md) | Adds a variable to a schedule |
| [New-GitlabScheduledPipeline](PipelineSchedules/New-GitlabScheduledPipeline.md) | Manually triggers a schedule |
| [Remove-GitlabPipelineSchedule](PipelineSchedules/Remove-GitlabPipelineSchedule.md) | Deletes a schedule |
| [Remove-GitlabPipelineScheduleVariable](PipelineSchedules/Remove-GitlabPipelineScheduleVariable.md) | Removes a schedule variable |
| [Update-GitlabPipelineSchedule](PipelineSchedules/Update-GitlabPipelineSchedule.md) | Updates schedule settings |
| [Update-GitlabPipelineScheduleVariable](PipelineSchedules/Update-GitlabPipelineScheduleVariable.md) | Updates a schedule variable |
