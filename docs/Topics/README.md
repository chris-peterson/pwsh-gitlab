# Topics

Manage project topics for categorization and discovery.

## Overview

Topics are tags that help categorize and organize projects across your GitLab instance. They make it easier to discover related projects and group them by technology, team, or purpose.

## Examples

```powershell
# Get all topics
Get-GitlabTopic

# Search for topics
Get-GitlabTopic -Search 'kubernetes'

# Create a new topic
New-GitlabTopic -Name 'microservices' -Description 'Microservice-based applications'

# Update a topic
Update-GitlabTopic -TopicId 123 -Description 'Updated description'

# Remove a topic
Remove-GitlabTopic -TopicId 123
```

> **Tip:** Use `Get-GitlabProject -Topics 'topic1', 'topic2'` to find projects with specific topics.

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabTopic](Topics/Get-GitlabTopic.md) | Gets topics |
| [New-GitlabTopic](Topics/New-GitlabTopic.md) | Creates a new topic |
| [Remove-GitlabTopic](Topics/Remove-GitlabTopic.md) | Deletes a topic |
| [Update-GitlabTopic](Topics/Update-GitlabTopic.md) | Updates a topic |
