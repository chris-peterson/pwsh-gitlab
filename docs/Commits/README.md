# Commits

View and analyze commit history.

## Overview

Commit cmdlets allow you to retrieve commit information from GitLab repositories, including filtering by date range, branch, and specific SHA. Useful for analyzing project history and tracking changes.

## Examples

```powershell
# Get recent commits from the current project
Get-GitlabCommit

# Get commits from a specific project
Get-GitlabCommit -ProjectId 'mygroup/myproject'

# Get a specific commit by SHA
Get-GitlabCommit -Sha 'abc123def456'

# Get commits from a branch
Get-GitlabCommit -Ref 'develop' -MaxPages 5

# Get commits within a date range
Get-GitlabCommit -After '2024-01-01' -Before '2024-12-31'
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabCommit](Commits/Get-GitlabCommit.md) | Retrieves commits from a repository |
