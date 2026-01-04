# AuditEvents

Track important actions within GitLab including user authentication, permission changes, and project/group modifications.

## Overview

Audit events provide a detailed log of security-relevant actions in your GitLab instance. This is essential for compliance, security monitoring, and troubleshooting. You can query audit events at the instance level (requires admin), group level, or project level.

## Examples

```powershell
# Get audit events for a group
Get-GitlabAuditEvent -GroupId 'mygroup'

# Get audit events filtered by date range
Get-GitlabAuditEvent -GroupId 'mygroup' -After '2024-01-01' -Before '2024-12-31'

# Get audit events with author information
Get-GitlabAuditEvent -ProjectId 'mygroup/myproject' -FetchAuthors
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabAuditEvent](AuditEvents/Get-GitlabAuditEvent.md) | Retrieves audit events at instance, group, or project level |
