# Milestones

Track and manage project and group milestones.

## Overview

Milestones help you track issues and merge requests towards a specific goal or release. They can be scoped to a project or group and include due dates for deadline tracking.

## Examples

```powershell
# Get milestones for the current project
Get-GitlabMilestone

# Get active milestones
Get-GitlabMilestone -State 'active'

# Get milestones for a group
Get-GitlabMilestone -GroupId 'mygroup'

# Get a specific milestone
Get-GitlabMilestone -ProjectId 'mygroup/myproject' -MilestoneId 5
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabMilestone](Milestones/Get-GitlabMilestone.md) | Retrieves milestones |
