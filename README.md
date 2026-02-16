
# <img src="docs/icon.png" width="72"/>`GitlabCli`

[![GitHub license](https://img.shields.io/github/license/chris-peterson/pwsh-gitlab.svg)](LICENSE)
[![Platforms](https://img.shields.io/powershellgallery/p/GitlabCli)](https://www.powershellgallery.com/packages/GitlabCli)
[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/GitlabCli)](https://www.powershellgallery.com/packages/GitlabCli)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/GitlabCli?color=green)](https://www.powershellgallery.com/packages/GitlabCli)
[![CodeQL](https://github.com/chris-peterson/pwsh-gitlab/actions/workflows/github-code-scanning/codeql/badge.svg)](https://github.com/chris-peterson/pwsh-gitlab/actions/workflows/github-code-scanning/codeql)
[![GitHub CI Status](https://img.shields.io/github/actions/workflow/status/chris-peterson/pwsh-gitlab/ci.yml?branch=main&label=ci)](https://github.com/chris-peterson/pwsh-gitlab/actions/workflows/ci.yml)

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

📖 See the [Quick Start Guide](https://chris-peterson.github.io/pwsh-gitlab/#/?id=quick-start) for setup instructions.

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

Run commands from within a git repo — the module automatically detects your project.
Use `.` for `ProjectId` or `BranchName` to use local git context:

```powershell
~/src/myproject> Get-GitlabPipeline -Latest
~/src/myproject> New-GitlabMergeRequest
~/src/myproject> Get-GitlabBranch .
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
Get-GitlabProject |
    Get-GitlabPipeline -Latest |
    Open-InBrowser
```

## Common Parameters

### Paging

| Parameter | Description |
| --- | --- |
| `-MaxPages` | Maximum number of pages to return _(default: `$global:GitlabDefaultMaxPages`)_ |
| `-All` | Return all pages. _NOTE:_ Overrides `-MaxPages` |
| `-Recurse` | Recurse child objects (e.g. `Get-GitlabProject -GroupId 'mygroup' -Recurse`). _NOTE:_ Implies `-All` pages |

### Safety

Mutable operations support [ShouldProcess](https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-shouldprocess):

| Parameter | Description |
| --- | --- |
| `-WhatIf` | Preview actions without executing |
| `-Confirm` | Prompt for confirmation before executing |

### Navigation

| Parameter | Description |
| --- | --- |
| `-Follow` | Open URL in browser after creating a resource |
| `-Wait` | Wait for long-running operations (e.g. pipelines) to complete |
| `-Select` | Select subset of response (shortcut for `Select-Object -ExpandProperty`) |

## Documentation

📖 **[chris-peterson.github.io/pwsh-gitlab](https://chris-peterson.github.io/pwsh-gitlab)**

- [Configuration Guide](https://chris-peterson.github.io/pwsh-gitlab/#/Config/)
- [All Cmdlets by Category](https://chris-peterson.github.io/pwsh-gitlab)
- [CI/CD: Pipelines & Jobs](https://chris-peterson.github.io/pwsh-gitlab/#/Pipelines/)
- [Working with Merge Requests](https://chris-peterson.github.io/pwsh-gitlab/#/MergeRequests/)

## Forge Ecosystem

`GitlabCli` is part of the **pwsh-forge** ecosystem — a unified PowerShell interface across software forges.

`GitlabCli` works standalone, but also integrates with [ForgeCli](https://github.com/chris-peterson/pwsh-forge)
so that commands like `Get-Issue` and `Get-MergeRequest` auto-dispatch to the right provider based on your git remote.

```powershell
Import-Module GitlabCli
Import-Module ForgeCli

cd ~/src/my-gitlab-project
Get-Issue              # routes to Get-GitlabIssue
Get-MergeRequest       # routes to Get-GitlabMergeRequest
```

| Module | Purpose |
|--------|---------|
| [pwsh-forge](https://github.com/chris-peterson/pwsh-forge) | Unified dispatch layer |
| **pwsh-gitlab** | :arrow_left: this module |
| [pwsh-github](https://github.com/chris-peterson/pwsh-github) | GitHub provider |

## Contributing

Contributions welcome! Please see the [GitHub repository](https://github.com/chris-peterson/pwsh-gitlab) for issues and pull requests.

## References

* [GitLab REST API Documentation](https://docs.gitlab.com/ee/api/rest/index.html)
* [PowerShell Gallery Package](https://www.powershellgallery.com/packages/GitlabCli)
* [PSGitLab](https://github.com/ngetchell/PSGitLab) — Inspiration (now archived)
* [powershell-yaml](https://github.com/cloudbase/powershell-yaml) — Dependency
