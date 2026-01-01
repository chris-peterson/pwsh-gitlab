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

- [AuditEvents](AuditEvents/) - Track important actions within GitLab
- [Branches](Branches/) - Manage repository branches
- [Commits](Commits/) - View commit information
- [Config](Config/) - Configure GitLab sites and connections
- [DeployKeys](DeployKeys/) - Manage deploy keys
- [Deployments](Deployments/) - View deployments
- [Environments](Environments/) - Manage environments
- [Git](Git/) - Local git context utilities
- [GraphQL](GraphQL/) - Execute GraphQL queries
- [GroupAccessTokens](GroupAccessTokens/) - Manage group access tokens
- [Groups](Groups/) - Manage GitLab groups
- [Integrations](Integrations/) - Configure project integrations
- [Issues](Issues/) - Work with issues
- [Jobs](Jobs/) - Manage CI/CD jobs
- [Keys](Keys/) - SSH key operations
- [Members](Members/) - Manage group and project members
- [MergeRequests](MergeRequests/) - Handle merge requests
- [Milestones](Milestones/) - Track milestones
- [Notes](Notes/) - Comments on issues and merge requests
- [PersonalAccessTokens](PersonalAccessTokens/) - Manage personal access tokens
- [Pipelines](Pipelines/) - Trigger and monitor pipelines
- [PipelineSchedules](PipelineSchedules/) - Schedule pipelines
- [ProjectAccessTokens](ProjectAccessTokens/) - Manage project access tokens
- [ProjectDeployKeys](ProjectDeployKeys/) - Manage project deploy keys
- [ProjectHooks](ProjectHooks/) - Configure webhooks
- [Projects](Projects/) - Manage projects
- [Releases](Releases/) - View releases
- [RepositoryFiles](RepositoryFiles/) - Access repository files
- [Runners](Runners/) - Configure CI/CD runners
- [Search](Search/) - Search GitLab
- [ServiceAccounts](ServiceAccounts/) - Manage service accounts
- [Snippets](Snippets/) - Manage code snippets
- [Todos](Todos/) - Manage todo items
- [Topics](Topics/) - Manage project topics
- [UserDeployKeys](UserDeployKeys/) - Manage user deploy keys
- [Users](Users/) - User management
- [Utilities](Utilities/) - Helper utilities
- [Variables](Variables/) - CI/CD variables

## Links

- [GitHub Repository](https://github.com/chris-peterson/pwsh-gitlab)
- [PowerShell Gallery](https://www.powershellgallery.com/packages/GitlabCli)
- [GitLab API Documentation](https://docs.gitlab.com/api/)
