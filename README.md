# Overview

Interact with GitLab via PowerShell

## Status

[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/GitLabCli)](https://www.powershellgallery.com/packages/GitlabCli)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/GitlabCli?color=green)](https://www.powershellgallery.com/packages/GitlabCli)
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/chris-peterson/pwsh-gitlab/CI?label=ci)](https://github.com/chris-peterson/pwsh-gitlab/actions/workflows/deploy.yml)

## Tech Stack

![image](TechStack.png)

## Getting Started

```powershell
Install-Module -Name GitlabCli
```

## Global Switches

`-WhatIf` : For mutable operations (or for some complex query operations), gives a preview of what actions would be taken.

## Global Behaviors

If invoking commands from within a git repository, `.` can be used for `ProjectId` / `BranchName` to use the local context.

## Examples

### Groups

#### `Get-GitLabGroup`

```powershell
Get-GitLabGroup 'mygroup'
```

```plaintext
  ID Name     Url
  -- ----     ---
  23 mygroup  https://gitlab.mydomain.com/mygroup
```

#### `Remove-GitLabGroup`

```powershell
Remove-GitLabGroup 'mygroup'
```

#### `Clone-GitLabGroup` (aka `Copy-GitLabGroupToLocalFileSystem`)

```powershell
Clone-GitLabGroup 'mygroup'
```

### Projects

#### `Get-GitLabProject` (by id)

```powershell
Get-GitLabProject 'mygroup/myproject'
# OR
Get-GitLabProject 42
# OR
Get-GitLabProject . # use local context
```

```plaintext
  ID Name        Group     Url
  -- ----        -----     ---
  42 myproject   mygroup   https://gitlab.mydomain.com/mygroup/myproject
```

#### `Get-GitLabProject` (by group)

```powershell
Get-GitLabProject -GroupId 'mygroup/subgroup'
```

```plaintext
  ID Name        Group             Url
  -- ----        -----             ---
   1 database    mygroup/subgroup  https://gitlab.mydomain.com/mygroup/subgroup/database
   2 infra       mygroup/subgroup  https://gitlab.mydomain.com/mygroup/subgroup/infra
   3 service     mygroup/subgroup  https://gitlab.mydomain.com/mygroup/subgroup/service
   4 website     mygroup/subgroup  https://gitlab.mydomain.com/mygroup/subgroup/website
```

_Optional Parameters_

`-IncludeArchived` - Set this switch to include archived projects.  _By default, archived projects are not returned_

### `Transfer-GitLabProject` (aka `Move-GitLabProject`)

```powershell
Transfer-GitLabProject -ProjectId 'this-project' -DestinationGroup 'that-group'
```

### Merge Requests

#### `New-GitLabMergeRequest` (aka `new-mr`)

```powershell
New-GitLabMergeRequest
```

_Optional Parameters_

`-ProjectId` - Defaults to local git context

`-SourceBranch` - Defaults to local git context

`-TargetBranch` - Defaults to the default branch set in repository config (typically `main`)

`-Title` - Defaults to space-delimited source branch name

`-Follow` - If provided, follow the URL after creation

Short version:

```powershell
new-mr -Follow
```

Creates a new merge request and follows the URL.

## References / Acknowledgements

* [PSGitLab](https://github.com/ngetchell/PSGitLab)
* [python-gitlab CLI documentation](https://python-gitlab.readthedocs.io/en/stable/)
