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

- [AuditEvents](AuditEvents/Get-GitlabAuditEvent.md) - Track important actions within GitLab
- [Branches](Branches/Get-GitlabBranch.md) - Manage repository branches
- [Commits](Commits/Get-GitlabCommit.md) - View commit information
- [Config](Config/Add-GitlabSite.md) - Configure GitLab sites and connections
- [DeployKeys](DeployKeys/Get-GitlabDeployKey.md) - Manage deploy keys
- [Deployments](Deployments/Get-GitlabDeployment.md) - View deployments
- [Environments](Environments/Get-GitlabEnvironment.md) - Manage environments
- [Git](Git/Get-LocalGitContext.md) - Local git context utilities
- [GraphQL](GraphQL/Invoke-GitlabGraphQL.md) - Execute GraphQL queries
- [GroupAccessTokens](GroupAccessTokens/Get-GitlabGroupAccessToken.md) - Manage group access tokens
- [Groups](Groups/Copy-GitlabGroupToLocalFileSystem.md) - Manage GitLab groups
- [Integrations](Integrations/Enable-GitlabProjectSlackNotification.md) - Configure project integrations
- [Issues](Issues/Close-GitlabIssue.md) - Work with issues
- [Jobs](Jobs/Get-GitlabJob.md) - Manage CI/CD jobs
- [Keys](Keys/Get-GitlabKey.md) - SSH key operations
- [Members](Members/Add-GitlabGroupMember.md) - Manage group and project members
- [MergeRequests](MergeRequests/Approve-GitlabMergeRequest.md) - Handle merge requests
- [Milestones](Milestones/Get-GitlabMilestone.md) - Track milestones
- [Notes](Notes/Get-GitlabIssueNote.md) - Comments on issues and merge requests
- [PersonalAccessTokens](PersonalAccessTokens/Get-GitlabPersonalAccessToken.md) - Manage personal access tokens
- [PipelineSchedules](PipelineSchedules/Disable-GitlabPipelineSchedule.md) - Schedule pipelines
- [Pipelines](Pipelines/Get-GitlabPipeline.md) - Trigger and monitor pipelines
- [ProjectAccessTokens](ProjectAccessTokens/Get-GitlabProjectAccessToken.md) - Manage project access tokens
- [ProjectDeployKeys](ProjectDeployKeys/Add-GitlabProjectDeployKey.md) - Manage project deploy keys
- [ProjectHooks](ProjectHooks/Get-GitlabProjectHook.md) - Configure webhooks
- [Projects](Projects/Add-GitlabProjectTopic.md) - Manage projects
- [Releases](Releases/Get-GitlabRelease.md) - View releases
- [RepositoryFiles](RepositoryFiles/Get-GitlabRepositoryFile.md) - Access repository files
- [Runners](Runners/Get-GitlabRunner.md) - Configure CI/CD runners
- [Search](Search/Search-Gitlab.md) - Search GitLab
- [ServiceAccounts](ServiceAccounts/Get-GitlabServiceAccount.md) - Manage service accounts
- [Snippets](Snippets/Get-GitlabSnippet.md) - Manage code snippets
- [Todos](Todos/Clear-GitlabTodo.md) - Manage todo items
- [Topics](Topics/Get-GitlabTopic.md) - Manage project topics
- [UserDeployKeys](UserDeployKeys/Get-GitlabUserDeployKey.md) - Manage user deploy keys
- [Users](Users/Block-GitlabUser.md) - User management
- [Utilities](Utilities/Get-FilteredObject.md) - Helper utilities
- [Variables](Variables/ConvertTo-GitlabVariables.md) - CI/CD variables

## Links

- [GitHub Repository](https://github.com/chris-peterson/pwsh-gitlab)
- [PowerShell Gallery](https://www.powershellgallery.com/packages/GitlabCli)
- [GitLab API Documentation](https://docs.gitlab.com/api/)
