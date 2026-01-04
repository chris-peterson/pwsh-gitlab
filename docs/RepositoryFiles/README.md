# RepositoryFiles

Access and manage files directly in GitLab repositories.

## Overview

These cmdlets provide direct access to repository files without needing a local clone. Read file contents, browse repository trees, and even create or update files through the API.

## Examples

```powershell
# Get file metadata
Get-GitlabRepositoryFile -FilePath 'README.md'

# Get file content from a specific branch
Get-GitlabRepositoryFileContent -FilePath 'config/settings.json' -Ref 'develop'

# Read YAML file content as an object
Get-GitlabRepositoryYmlFileContent -FilePath '.gitlab-ci.yml'

# Browse repository structure
Get-GitlabRepositoryTree -Path 'src' -Recursive

# Create a new file
New-GitlabRepositoryFile -FilePath 'docs/new-doc.md' -Content '# New Doc' -CommitMessage 'Add documentation'

# Update an existing file
Update-GitlabRepositoryFile -FilePath 'VERSION' -Content '2.0.0' -CommitMessage 'Bump version'
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-GitlabRepositoryFile](RepositoryFiles/Get-GitlabRepositoryFile.md) | Gets file metadata |
| [Get-GitlabRepositoryFileContent](RepositoryFiles/Get-GitlabRepositoryFileContent.md) | Gets decoded file content |
| [Get-GitlabRepositoryTree](RepositoryFiles/Get-GitlabRepositoryTree.md) | Lists repository structure |
| [Get-GitlabRepositoryYmlFileContent](RepositoryFiles/Get-GitlabRepositoryYmlFileContent.md) | Gets YAML content as object |
| [New-GitlabRepositoryFile](RepositoryFiles/New-GitlabRepositoryFile.md) | Creates a new file |
| [Update-GitlabRepositoryFile](RepositoryFiles/Update-GitlabRepositoryFile.md) | Updates an existing file |
