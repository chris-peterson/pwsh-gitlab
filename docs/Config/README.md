# Config

Configure GitLab sites and manage connections to multiple GitLab instances.

## Overview

These cmdlets manage your GitLab CLI configuration, allowing you to connect to multiple GitLab instances (gitlab.com, self-hosted, etc.) and switch between them seamlessly. Configuration supports personal access tokens and proxy settings.

## Examples

```powershell
# Add a new GitLab site
Add-GitlabSite -Url 'https://gitlab.example.com' -AccessToken 'glpat-xxxx' -IsDefault

# View current configuration
Get-GitlabConfiguration

# Get the default site
Get-DefaultGitlabSite

# Switch default site
Set-DefaultGitlabSite -Url 'https://gitlab.com'

# Remove a configured site
Remove-GitlabSite -Url 'https://old-gitlab.example.com'
```

> **Tip:** You can also configure GitLab access via the `$env:GITLAB_ACCESS_TOKEN` environment variable for quick setup or CI/CD environments.

## Cmdlets

| Cmdlet | Description |
|--------|-------------|
| [Add-GitlabSite](Config/Add-GitlabSite.md) | Adds a new GitLab site configuration |
| [Get-DefaultGitlabSite](Config/Get-DefaultGitlabSite.md) | Gets the default GitLab site |
| [Get-GitlabConfiguration](Config/Get-GitlabConfiguration.md) | Gets the full configuration |
| [Remove-GitlabSite](Config/Remove-GitlabSite.md) | Removes a configured site |
| [Set-DefaultGitlabSite](Config/Set-DefaultGitlabSite.md) | Sets the default site |
