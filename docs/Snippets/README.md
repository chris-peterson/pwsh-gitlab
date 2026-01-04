# Snippets

Manage code snippets for sharing and reuse.

## Overview

Snippets are a way to share small pieces of code or text. They can be personal or project-specific and support multiple files. Great for sharing configuration examples, code samples, or quick scripts.

## Examples

```powershell
# Get your snippets
Get-GitlabSnippet

# Get snippet content
Get-GitlabSnippetContent -SnippetId 123

# Create a new snippet
New-GitlabSnippet -Title 'Useful script' -FileName 'script.ps1' -Content '$content' -Visibility 'private'

# Update a snippet
Update-GitlabSnippet -SnippetId 123 -Title 'Updated title'

# Delete a snippet
Remove-GitlabSnippet -SnippetId 123
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabSnippet](Snippets/Get-GitlabSnippet.md) | Retrieves snippets |
| [Get-GitlabSnippetContent](Snippets/Get-GitlabSnippetContent.md) | Gets snippet file content |
| [New-GitlabSnippet](Snippets/New-GitlabSnippet.md) | Creates a new snippet |
| [Remove-GitlabSnippet](Snippets/Remove-GitlabSnippet.md) | Deletes a snippet |
| [Update-GitlabSnippet](Snippets/Update-GitlabSnippet.md) | Updates a snippet |
