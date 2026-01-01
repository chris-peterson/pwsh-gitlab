# pwsh-gitlab

> PowerShell module for GitLab automation

[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/GitlabCli.svg)](https://www.powershellgallery.com/packages/GitlabCli)
[![GitHub](https://img.shields.io/github/license/chris-peterson/pwsh-gitlab)](https://github.com/chris-peterson/pwsh-gitlab/blob/main/LICENSE)

## Overview

`pwsh-gitlab` is a PowerShell module that provides cmdlets for interacting with the GitLab REST API. It enables automation of GitLab operations directly from PowerShell.

## Installation

```powershell
Install-Module -Name GitlabCli
```

## Quick Start

```powershell
# Configure your GitLab connection
Add-GitlabSite -Url "https://gitlab.com" -AccessToken $token

# Get projects
Get-GitlabProject -GroupId "mygroup"

# Get merge requests
Get-GitlabMergeRequest -ProjectId "mygroup/myproject" -State opened

# Run a pipeline
Invoke-GitlabPipeline -ProjectId "mygroup/myproject" -Ref main
```

## Getting Help

Use PowerShell's built-in help:

```powershell
# List all cmdlets
Get-Command -Module GitlabCli

# Get help for a specific cmdlet
Get-Help Get-GitlabProject -Full

# Open online documentation
Get-Help Get-GitlabProject -Online
```

## Cmdlet Categories

Browse the sidebar to find cmdlets organized by category:

- **AuditEvents** - Track important actions within GitLab
- **Branches** - Manage repository branches
- **Commits** - View commit information
- **Config** - Configure GitLab sites and connections
- **Groups** - Manage GitLab groups
- **Issues** - Work with issues
- **Jobs** - Manage CI/CD jobs
- **MergeRequests** - Handle merge requests
- **Pipelines** - Trigger and monitor pipelines
- **Projects** - Manage projects
- **Runners** - Configure CI/CD runners
- **Users** - User management

## Links

- [GitHub Repository](https://github.com/chris-peterson/pwsh-gitlab)
- [PowerShell Gallery](https://www.powershellgallery.com/packages/GitlabCli)
- [GitLab API Documentation](https://docs.gitlab.com/api/)
