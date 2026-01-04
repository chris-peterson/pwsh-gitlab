# Issues

Create, track, and manage project issues.

## Overview

Issues are the primary way to track work, bugs, and feature requests in GitLab. These cmdlets provide full issue lifecycle management from creation through closure, with filtering and update capabilities.

## Examples

```powershell
# Get open issues from the current project
Get-GitlabIssue

# Get closed issues from a specific project
Get-GitlabIssue -ProjectId 'mygroup/myproject' -State closed

# Get issues assigned to you
Get-GitlabIssue -Mine

# Create a new issue
New-GitlabIssue -Title 'Bug: Something is broken' -Description 'Details here...'

# Close an issue
Close-GitlabIssue -IssueId 123

# Update an issue
Update-GitlabIssue -IssueId 123 -Labels 'bug', 'priority::high'
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Close-GitlabIssue](Issues/Close-GitlabIssue.md) | Closes an issue |
| [Get-GitlabIssue](Issues/Get-GitlabIssue.md) | Retrieves issues |
| [New-GitlabIssue](Issues/New-GitlabIssue.md) | Creates a new issue |
| [Open-GitlabIssue](Issues/Open-GitlabIssue.md) | Reopens a closed issue |
| [Update-GitlabIssue](Issues/Update-GitlabIssue.md) | Updates an issue |

## Aliases

- `issue` → `Get-GitlabIssue`
- `issues` → `Get-GitlabIssue`
