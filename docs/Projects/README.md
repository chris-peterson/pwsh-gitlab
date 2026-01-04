# Projects

Manage GitLab projects including settings, variables, topics, and sharing.

## Overview

Projects are the core organizational unit in GitLab, containing repositories, CI/CD pipelines, issues, and more. These cmdlets provide comprehensive project management capabilities including creation, archival, variable management, and cross-group sharing.

## Examples

```powershell
# Get the current project (from local git context)
Get-GitlabProject

# Get a specific project by path
Get-GitlabProject -ProjectId 'mygroup/myproject'

# Get all projects in a group recursively
Get-GitlabProject -GroupId 'mygroup' -Recurse -All

# Get projects by topic
Get-GitlabProject -Topics 'kubernetes', 'helm'

# Create a new project
New-GitlabProject -Name 'my-new-project' -GroupId 'mygroup'

# Archive a project
Invoke-GitlabProjectArchival -ProjectId 'mygroup/old-project'
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Add-GitlabProjectTopic](Projects/Add-GitlabProjectTopic.md) | Adds topics to a project |
| [ConvertTo-GitlabTriggerYaml](Projects/ConvertTo-GitlabTriggerYaml.md) | Converts trigger configuration to YAML |
| [Copy-GitlabProject](Projects/Copy-GitlabProject.md) | Forks or copies a project |
| [Get-GitlabProject](Projects/Get-GitlabProject.md) | Retrieves project information |
| [Get-GitlabProjectEvent](Projects/Get-GitlabProjectEvent.md) | Gets project activity events |
| [Get-GitlabProjectVariable](Projects/Get-GitlabProjectVariable.md) | Gets CI/CD variables |
| [Invoke-GitlabProjectArchival](Projects/Invoke-GitlabProjectArchival.md) | Archives a project |
| [Invoke-GitlabProjectUnarchival](Projects/Invoke-GitlabProjectUnarchival.md) | Unarchives a project |
| [Move-GitlabProject](Projects/Move-GitlabProject.md) | Transfers a project to another group |
| [New-GitlabGroupToProjectShare](Projects/New-GitlabGroupToProjectShare.md) | Shares a project with a group |
| [New-GitlabProject](Projects/New-GitlabProject.md) | Creates a new project |
| [Remove-GitlabGroupToProjectShare](Projects/Remove-GitlabGroupToProjectShare.md) | Removes project sharing |
| [Remove-GitlabProject](Projects/Remove-GitlabProject.md) | Deletes a project |
| [Remove-GitlabProjectForkRelationship](Projects/Remove-GitlabProjectForkRelationship.md) | Removes fork relationship |
| [Remove-GitlabProjectTopic](Projects/Remove-GitlabProjectTopic.md) | Removes topics from a project |
| [Remove-GitlabProjectVariable](Projects/Remove-GitlabProjectVariable.md) | Removes a CI/CD variable |
| [Rename-GitlabProject](Projects/Rename-GitlabProject.md) | Renames a project |
| [Rename-GitlabProjectDefaultBranch](Projects/Rename-GitlabProjectDefaultBranch.md) | Changes the default branch |
| [Set-GitlabProjectVariable](Projects/Set-GitlabProjectVariable.md) | Sets a CI/CD variable |
| [Update-GitlabProject](Projects/Update-GitlabProject.md) | Updates project settings |
