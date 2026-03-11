# Tags

Manage GitLab repository tags.

## Overview

Tags mark specific points in a repository's history and are commonly used to mark release versions. These cmdlets let you list, create, and delete repository tags.

## Examples

```powershell
# Get all tags from the current project
Get-GitlabTag

# Get a specific tag
Get-GitlabTag -Name 'v1.0.0'

# Create a new tag from main
New-GitlabTag -Name 'v2.0.0' -Ref 'main' -Message 'Version 2.0.0'

# Delete a tag
Remove-GitlabTag -Name 'v0.1.0'
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabTag](Tags/Get-GitlabTag.md) | Gets repository tags |
| [New-GitlabTag](Tags/New-GitlabTag.md) | Creates a new tag |
| [Remove-GitlabTag](Tags/Remove-GitlabTag.md) | Deletes a tag |

## Aliases

- `tags` → `Get-GitlabTag`
