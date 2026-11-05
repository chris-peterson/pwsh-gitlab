# PipelineTriggers

Manage pipeline trigger tokens.

## Overview

A pipeline trigger token lets another system, or another project's pipeline, start a pipeline in a project. The pipeline runs with the permissions of the token's owner.

## Examples

```powershell
# List a project's trigger tokens
Get-GitlabPipelineTrigger -ProjectId 'my-group/my-project'

# Create a trigger token
New-GitlabPipelineTrigger -ProjectId 'my-group/my-project' -Description 'deploy from upstream'

# Delete a trigger token
Remove-GitlabPipelineTrigger -ProjectId 'my-group/my-project' -TriggerId 12
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabPipelineTrigger](PipelineTriggers/Get-GitlabPipelineTrigger.md) | Gets a project's pipeline trigger tokens |
| [New-GitlabPipelineTrigger](PipelineTriggers/New-GitlabPipelineTrigger.md) | Creates a pipeline trigger token |
| [Remove-GitlabPipelineTrigger](PipelineTriggers/Remove-GitlabPipelineTrigger.md) | Deletes a pipeline trigger token |
