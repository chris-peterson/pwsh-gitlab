# Integrations

Configure project integrations with external services.

## Overview

Integrations connect GitLab projects to external services like Slack, Jira, and more. These cmdlets let you configure and manage these connections programmatically.

## Examples

```powershell
# Get all integrations for a project
Get-GitlabProjectIntegration -ProjectId 'mygroup/myproject'

# Get a specific integration
Get-GitlabProjectIntegration -ProjectId 'mygroup/myproject' -Integration 'slack'

# Enable Slack notifications
Enable-GitlabProjectSlackNotification -ProjectId 'mygroup/myproject' -WebhookUrl 'https://hooks.slack.com/...' -Channel '#builds'

# Update an integration
Update-GitlabProjectIntegration -ProjectId 'mygroup/myproject' -Integration 'jira' -Properties @{url='https://jira.example.com'}

# Remove an integration
Remove-GitlabProjectIntegration -ProjectId 'mygroup/myproject' -Integration 'slack'
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Enable-GitlabProjectSlackNotification](Integrations/Enable-GitlabProjectSlackNotification.md) | Configures Slack notifications |
| [Get-GitlabProjectIntegration](Integrations/Get-GitlabProjectIntegration.md) | Gets project integrations |
| [Remove-GitlabProjectIntegration](Integrations/Remove-GitlabProjectIntegration.md) | Removes an integration |
| [Update-GitlabProjectIntegration](Integrations/Update-GitlabProjectIntegration.md) | Updates integration settings |
