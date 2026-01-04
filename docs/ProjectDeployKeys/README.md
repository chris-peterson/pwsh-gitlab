# ProjectDeployKeys

Manage deploy keys for individual projects.

## Overview

Project deploy keys grant SSH access to a specific project's repository. They're commonly used by CI/CD systems, deployment tools, and automated processes that need to clone or pull from repositories.

## Examples

```powershell
# Get deploy keys for a project
Get-GitlabProjectDeployKey -ProjectId 'mygroup/myproject'

# Add a new deploy key
Add-GitlabProjectDeployKey -ProjectId 'mygroup/myproject' -Title 'CI Server' -Key 'ssh-rsa AAAA...' -CanPush $false

# Enable an existing deploy key from another project
Enable-GitlabProjectDeployKey -ProjectId 'mygroup/myproject' -KeyId 123

# Allow push access for a deploy key
Update-GitlabProjectDeployKey -ProjectId 'mygroup/myproject' -KeyId 123 -CanPush $true

# Remove a deploy key
Remove-GitlabProjectDeployKey -ProjectId 'mygroup/myproject' -KeyId 123
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Add-GitlabProjectDeployKey](ProjectDeployKeys/Add-GitlabProjectDeployKey.md) | Adds a deploy key to a project |
| [Enable-GitlabProjectDeployKey](ProjectDeployKeys/Enable-GitlabProjectDeployKey.md) | Enables an existing key |
| [Get-GitlabProjectDeployKey](ProjectDeployKeys/Get-GitlabProjectDeployKey.md) | Gets project deploy keys |
| [Remove-GitlabProjectDeployKey](ProjectDeployKeys/Remove-GitlabProjectDeployKey.md) | Removes a deploy key |
| [Update-GitlabProjectDeployKey](ProjectDeployKeys/Update-GitlabProjectDeployKey.md) | Updates deploy key settings |
