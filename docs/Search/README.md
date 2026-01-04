# Search

Search across GitLab for code, merge requests, and projects.

## Overview

GitLab's search functionality lets you find code, merge requests, and projects across your entire instance or within specific groups. Great for finding code patterns, discovering dependencies, or locating specific configurations.

## Examples

```powershell
# Search for code containing a term
Search-Gitlab 'TODO'

# Search within a group for files
Search-Gitlab -GroupId 'my-group' -Filename 'config.yaml' -Search 'database'

# Search for merge requests
Search-Gitlab -Scope merge_requests -Search 'fix bug'

# Search and open results in browser
Search-Gitlab -Search 'deprecated function' -OpenInBrowser

# Search projects by name
Search-GitlabProject 'api-gateway'
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Search-Gitlab](Search/Search-Gitlab.md) | Searches for blobs, MRs, or projects |
| [Search-GitlabProject](Search/Search-GitlabProject.md) | Searches for projects by name |
