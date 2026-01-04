# Utilities

Helper utilities for common tasks and low-level API access.

## Overview

These utility cmdlets provide foundational functionality including direct API access, object filtering, version checking, and browser integration.

## Examples

```powershell
# Check GitLab version
Get-GitlabVersion

# Make a direct API call
Invoke-GitlabApi -HttpMethod GET -Path 'projects/123'

# Open a GitLab URL in browser
Open-InBrowser -Url 'https://gitlab.com/mygroup/myproject'

# Filter objects with custom criteria
$projects | Get-FilteredObject -Property 'name' -Like '*api*'
```

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Get-FilteredObject](Utilities/Get-FilteredObject.md) | Filters objects by property values |
| [Get-GitlabVersion](Utilities/Get-GitlabVersion.md) | Gets the GitLab instance version |
| [Invoke-GitlabApi](Utilities/Invoke-GitlabApi.md) | Makes direct GitLab API calls |
| [Open-InBrowser](Utilities/Open-InBrowser.md) | Opens URLs in default browser |
