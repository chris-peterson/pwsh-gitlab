# ProjectHooks

Configure webhooks for project events.

## Overview

Webhooks notify external services when events occur in your GitLab project (pushes, merge requests, pipeline events, etc.). Use these cmdlets to manage webhook configurations programmatically.

## Examples

```powershell
# Get all webhooks for a project
Get-GitlabProjectHook -ProjectId 'mygroup/myproject'

# Create a new webhook
New-GitlabProjectHook -ProjectId 'mygroup/myproject' -Url 'https://webhook.example.com/notify' -PushEvents -MergeRequestsEvents

# Update a webhook
Update-GitlabProjectHook -ProjectId 'mygroup/myproject' -HookId 123 -EnableSslVerification $true

# Remove a webhook
Remove-GitlabProjectHook -ProjectId 'mygroup/myproject' -HookId 123
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabProjectHook](ProjectHooks/Get-GitlabProjectHook.md) | Gets project webhooks |
| [New-GitlabProjectHook](ProjectHooks/New-GitlabProjectHook.md) | Creates a webhook |
| [Remove-GitlabProjectHook](ProjectHooks/Remove-GitlabProjectHook.md) | Deletes a webhook |
| [Update-GitlabProjectHook](ProjectHooks/Update-GitlabProjectHook.md) | Updates webhook settings |
