# Notes

Manage comments on issues and merge requests.

## Overview

Notes (comments) facilitate discussion and collaboration on issues and merge requests. These cmdlets let you read existing comments and add new ones programmatically.

## Examples

```powershell
# Get comments on an issue
Get-GitlabIssueNote -ProjectId 'mygroup/myproject' -IssueId 123

# Get comments on a merge request
Get-GitlabMergeRequestNote -ProjectId 'mygroup/myproject' -MergeRequestId 456

# Add a comment to an issue
New-GitlabIssueNote -ProjectId 'mygroup/myproject' -IssueId 123 -Body 'Thanks for reporting this!'
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabIssueNote](Notes/Get-GitlabIssueNote.md) | Gets issue comments |
| [Get-GitlabMergeRequestNote](Notes/Get-GitlabMergeRequestNote.md) | Gets merge request comments |
| [New-GitlabIssueNote](Notes/New-GitlabIssueNote.md) | Creates a new issue comment |
