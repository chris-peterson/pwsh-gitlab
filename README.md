# GitlabCli

<img src="assets/icon.png" width="64">&zwnj;
[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/GitlabCli)](https://www.powershellgallery.com/packages/GitlabCli)
[![Platforms](https://img.shields.io/powershellgallery/p/GitlabCli)](https://www.powershellgallery.com/packages/GitlabCli)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/GitlabCli?color=green)](https://www.powershellgallery.com/packages/GitlabCli)
[![GitHub license](https://img.shields.io/github/license/chris-peterson/pwsh-gitlab.svg)](LICENSE)
[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/chris-peterson/pwsh-gitlab/ci.yml?branch=main&label=ci)](https://github.com/chris-peterson/pwsh-gitlab/actions/workflows/ci.yml)

Interact with [GitLab](https://about.gitlab.com/) via [PowerShell](https://github.com/powershell/powershell#-powershell).

📖 **[Full Documentation](https://chris-peterson.github.io/pwsh-gitlab)** — Browse cmdlets, examples, and guides.

## Installation

### PowerShell Gallery

```powershell
Install-Module -Name GitlabCli
```

### Docker

```sh
docker run -it ghcr.io/chris-peterson/pwsh-gitlab/gitlab-cli
```

## Quick Start

### 1. Get a Personal Access Token

Create a PAT at `https://<your-gitlab-instance>/-/profile/personal_access_tokens`

### 2. Configure

**Option A: Environment Variables** (simple)

```powershell
$env:GITLAB_ACCESS_TOKEN = '<your-token>'
$env:GITLAB_URL = 'gitlab.example.com'  # optional, defaults to gitlab.com
```

**Option B: Configuration File** (multiple sites)

```powershell
Add-GitlabSite -Url 'https://gitlab.example.com' -AccessToken '<your-token>' -IsDefault
```

### 3. Start Using

```powershell
# Get the current project (from local git context)
Get-GitlabProject

# Create a merge request from your current branch
New-GitlabMergeRequest

# Trigger a pipeline
New-GitlabPipeline

# Search for code
Search-Gitlab 'TODO'
```

## Features at a Glance

| Category | What You Can Do |
|----------|-----------------|
| **[Projects](https://chris-peterson.github.io/pwsh-gitlab/#/Projects/)** | Create, clone, archive, manage variables and settings |
| **[Merge Requests](https://chris-peterson.github.io/pwsh-gitlab/#/MergeRequests/)** | Create, review, approve, and merge |
| **[Pipelines](https://chris-peterson.github.io/pwsh-gitlab/#/Pipelines/)** | Trigger, monitor, and manage CI/CD |
| **[Groups](https://chris-peterson.github.io/pwsh-gitlab/#/Groups/)** | Organize projects, manage membership |
| **[And more...](https://chris-peterson.github.io/pwsh-gitlab)** | Issues, Runners, Environments, GraphQL, etc. |

## Highlights

### Context-Aware Commands

Run commands from within a git repo — the module automatically detects your project:

```powershell
~/src/myproject> Get-GitlabPipeline -Latest
~/src/myproject> New-GitlabMergeRequest
```

### Convenient Aliases

```powershell
pipelines          # Get-GitlabPipeline
jobs               # Get-GitlabJob
mr                 # Get or create merge request
build              # New-GitlabPipeline
go                 # Open-InBrowser
```

### Pipeline to Browser

```powershell
Get-GitlabProject | Get-GitlabPipeline -Latest | Open-InBrowser
```

## Documentation

📖 **[chris-peterson.github.io/pwsh-gitlab](https://chris-peterson.github.io/pwsh-gitlab)**

- [Configuration Guide](https://chris-peterson.github.io/pwsh-gitlab/#/Config/)
- [All Cmdlets by Category](https://chris-peterson.github.io/pwsh-gitlab)
- [CI/CD: Pipelines & Jobs](https://chris-peterson.github.io/pwsh-gitlab/#/Pipelines/)
- [Working with Merge Requests](https://chris-peterson.github.io/pwsh-gitlab/#/MergeRequests/)

## Contributing

Contributions welcome! Please see the [GitHub repository](https://github.com/chris-peterson/pwsh-gitlab) for issues and pull requests.

## References

* [GitLab REST API Documentation](https://docs.gitlab.com/ee/api/rest/index.html)
* [PowerShell Gallery Package](https://www.powershellgallery.com/packages/GitlabCli)
