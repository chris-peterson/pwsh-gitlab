# Labels

Manage GitLab project and group labels.

## Overview

Labels help you categorize and filter issues, merge requests, and epics in GitLab. They can be scoped to a project or group. These cmdlets let you list, create, update, and delete labels.

## Examples

```powershell
# Get all labels in the current project
Get-GitlabLabel

# Get labels for a group, including ancestor groups
Get-GitlabLabel -GroupId 'mygroup' -IncludeAncestorGroups

# Create a new label
New-GitlabLabel -Name 'bug' -Color '#FF0000' -Description 'Bug reports'

# Delete a label
Remove-GitlabLabel -LabelId 42
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabLabel](Labels/Get-GitlabLabel.md) | Gets labels from a project or group |
| [New-GitlabLabel](Labels/New-GitlabLabel.md) | Creates a new label |
| [Update-GitlabLabel](Labels/Update-GitlabLabel.md) | Updates an existing label |
| [Remove-GitlabLabel](Labels/Remove-GitlabLabel.md) | Deletes a label |

## Aliases

- `labels` → `Get-GitlabLabel`
