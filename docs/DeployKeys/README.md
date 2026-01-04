# DeployKeys

Manage instance-level deploy keys.

## Overview

Deploy keys are SSH keys that grant read-only or read-write access to repositories. They're commonly used for deployment automation and CI/CD systems that need to pull code.

## Examples

```powershell
# Get all deploy keys
Get-GitlabDeployKey

# Get a specific deploy key
Get-GitlabDeployKey -KeyId 123
```

> **Note:** For project-specific deploy keys, see [ProjectDeployKeys](ProjectDeployKeys/).

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabDeployKey](DeployKeys/Get-GitlabDeployKey.md) | Gets deploy keys |
