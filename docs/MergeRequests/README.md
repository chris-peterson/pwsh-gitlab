# MergeRequests

Create, review, approve, and merge merge requests.

## Overview

Merge requests are the cornerstone of collaborative code development in GitLab. These cmdlets provide full lifecycle management from creation through approval and merge, including support for approval rules and configurations.

## Examples

```powershell
# Create a merge request from the current branch
New-GitlabMergeRequest

# Create and open in browser
New-GitlabMergeRequest -Follow

# Get open merge requests for a project
Get-GitlabMergeRequest -State 'opened'

# Get merge requests assigned to you
Get-GitlabMergeRequest -AssignedToMe

# Approve a merge request
Approve-GitlabMergeRequest -ProjectId 'mygroup/myproject' -MergeRequestId 123

# Merge when pipeline succeeds
Merge-GitlabMergeRequest -MergeRequestId 123 -MergeWhenPipelineSucceeds
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Approve-GitlabMergeRequest](MergeRequests/Approve-GitlabMergeRequest.md) | Approves a merge request |
| [Close-GitlabMergeRequest](MergeRequests/Close-GitlabMergeRequest.md) | Closes a merge request |
| [Get-GitlabMergeRequest](MergeRequests/Get-GitlabMergeRequest.md) | Retrieves merge requests |
| [Get-GitlabMergeRequestApprovalConfiguration](MergeRequests/Get-GitlabMergeRequestApprovalConfiguration.md) | Gets approval settings |
| [Get-GitlabMergeRequestApprovalRule](MergeRequests/Get-GitlabMergeRequestApprovalRule.md) | Gets approval rules |
| [Invoke-GitlabMergeRequestReview](MergeRequests/Invoke-GitlabMergeRequestReview.md) | Opens MR for interactive review |
| [Merge-GitlabMergeRequest](MergeRequests/Merge-GitlabMergeRequest.md) | Merges a merge request |
| [New-GitlabMergeRequest](MergeRequests/New-GitlabMergeRequest.md) | Creates a new merge request |
| [New-GitlabMergeRequestApprovalRule](MergeRequests/New-GitlabMergeRequestApprovalRule.md) | Creates an approval rule |
| [Remove-GitlabMergeRequestApprovalRule](MergeRequests/Remove-GitlabMergeRequestApprovalRule.md) | Removes an approval rule |
| [Set-GitlabMergeRequest](MergeRequests/Set-GitlabMergeRequest.md) | Updates merge request properties |
| [Update-GitlabMergeRequest](MergeRequests/Update-GitlabMergeRequest.md) | Updates a merge request |
| [Update-GitlabMergeRequestApprovalConfiguration](MergeRequests/Update-GitlabMergeRequestApprovalConfiguration.md) | Updates approval settings |
