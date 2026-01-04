# Keys

Look up SSH keys across the GitLab instance.

## Overview

SSH keys are used for Git authentication. This cmdlet helps administrators look up SSH key ownership, useful for security audits and troubleshooting.

## Examples

```powershell
# Look up an SSH key by fingerprint
Get-GitlabKey -Fingerprint 'SHA256:abc123...'

# Look up who owns a specific key
Get-GitlabKey -KeyId 456
```

> **Note:** This is typically used by administrators for security and audit purposes.

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabKey](Keys/Get-GitlabKey.md) | Gets SSH key information |
