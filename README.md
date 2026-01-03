
# <img src="docs/icon.png" width="72"/>`GitlabCli`

[![GitHub license](https://img.shields.io/github/license/chris-peterson/pwsh-gitlab.svg)](LICENSE)
[![Platforms](https://img.shields.io/powershellgallery/p/GitlabCli)](https://www.powershellgallery.com/packages/GitlabCli)
[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/GitlabCli)](https://www.powershellgallery.com/packages/GitlabCli)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/GitlabCli?color=green)](https://www.powershellgallery.com/packages/GitlabCli)
[![CodeQL](https://github.com/chris-peterson/pwsh-gitlab/actions/workflows/github-code-scanning/codeql/badge.svg)](https://github.com/chris-peterson/pwsh-gitlab/actions/workflows/github-code-scanning/codeql)
[![GitHub CI Status](https://img.shields.io/github/actions/workflow/status/chris-peterson/pwsh-gitlab/ci.yml?branch=main&label=ci)](https://github.com/chris-peterson/pwsh-gitlab/actions/workflows/ci.yml)

 Interact with [GitLab](https://about.gitlab.com/) via [PowerShell](https://github.com/powershell/powershell#-powershell)

## Getting Started

### Module

```powershell
Install-Module -Name GitlabCli
```

### Docker Image

```sh
docker run -it ghcr.io/chris-peterson/pwsh-gitlab/gitlab-cli
```

### Configuration

#### Environment Variables

##### `$env:GITLAB_ACCESS_TOKEN`

Obtain a "Personal Access Token" (PAT) for your GitLab instance

`https://<your gitlab instance>/-/profile/personal_access_tokens`

<img width=600 src="PersonalAccessToken.jpg"/>

Make the value available via

`$env:GITLAB_ACCESS_TOKEN='<your pat>'`.

One way to do this would be to add a line to your `$PROFILE`

##### `$env:GITLAB_URL`

(Optional) If using a gitlab instance that is not `gitlab.com`, provide it via:

`$env:GITLAB_URL='<your gitlab instance>'`

#### Example PowerShell Profile

```powershell
$env:GITLAB_URL='gitlab.mydomain.com'
$env:GITLAB_ACCESS_TOKEN='<my token>'
Import-Module GitlabCli
```

#### Configuration File

The following commands can be used to configure your system for use with **multiple** gitlab sites.

* `Add-GitlabSite`
* `Remove-GitlabSite`
* `Set-DefaultGitlabSite`

## Common Parameters: Paging

The following parameters control pagination for query operations:

| Parameter | Description |
| --- | --- |
| `-MaxPages` | Maximum number of pages to return _(default: `$global:GitlabDefaultMaxPages`)_ |
| `-All` | Return all pages. _NOTE:_ Overrides `-MaxPages` |
| `-Recurse` | Recurse child objects (e.g. `Get-GitlabProject -GroupId 'mygroup' -Recurse`). _NOTE:_ Implies `-All` pages |

## Common Parameters: Safety

Mutable operations in this module support ["should process"](https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-shouldprocess?view=powershell-7.5).

| Parameter | Description |
| --- | --- |
| `-WhatIf` | Preview what actions would be taken without executing them |
| `-Confirm` | Prompt for confirmation before executing mutable operations |

## Common Parameters: Navigation

The following parameters control post-operation behavior:

| Parameter | Description |
| --- | --- |
| `-Follow` | For operations that create a resource, follow the URL after creation |
| `-Wait` | For long-running operations (e.g. running a job/pipeline), wait for operation to complete. In the meantime, the status is polled and reported to the terminal |

## Common Parameters: Other

The following parameters are supported when possible:

| Parameter | Description |
| --- | --- |
| `-Select` | Select subset of response. A shortcut for `\| Select-Object -ExpandProperty`.  _NOTE:_ can select multiple properties (comma-separated) |
| `-SiteUrl` | Override site url _(default: inferred from local git context)_ |

## Global Behaviors

If invoking commands from within a git repository, `.` can be used for `ProjectId` / `BranchName` to use the local context.

Most objects returned from commands have a `Url` property.  This makes it so you can pipe one or more objects to `Open-InBrowser` (aka `go`)

## Examples

### Groups

#### `Get-GitlabGroup`

```powershell
Get-GitlabGroup 'mygroup'
```

```plaintext
  ID Name     Url
  -- ----     ---
  23 mygroup  https://gitlab.mydomain.com/mygroup
```

#### `Remove-GitlabGroup`

```powershell
Remove-GitlabGroup 'mygroup'
```

#### `Clone-GitlabGroup` (aka `Copy-GitlabGroupToLocalFileSystem`)

```powershell
Clone-GitlabGroup 'mygroup'
```

### Projects

#### `Get-GitlabProject` (by id)

```powershell
Get-GitlabProject 'mygroup/myproject'
# OR
Get-GitlabProject 42
# OR
Get-GitlabProject # use local context
```

```plaintext
  ID Name        Group     Url
  -- ----        -----     ---
  42 myproject   mygroup   https://gitlab.mydomain.com/mygroup/myproject
```

#### `Get-GitlabProject` (by group)

```powershell
Get-GitlabProject -GroupId 'mygroup/subgroup'
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

#### `Transfer-GitlabProject` (aka `Move-GitlabProject`)

```powershell
Transfer-GitlabProject -ProjectId 'this-project' -DestinationGroup 'that-group'
```

### Merge Requests

#### `New-GitlabMergeRequest`

```powershell
New-GitlabMergeRequest
```

_Optional Parameters_

`-ProjectId` - Defaults to local git context

`-SourceBranch` - Defaults to local git context

`-TargetBranch` - Defaults to the default branch set in repository config (typically `main`)

`-Title` - Defaults to space-delimited source branch name

## Other Examples

### `mr`

Create or get merge request for current git context

### Get Deployment

```powershell
Get-GitlabDeployment -Status 'created' -Environment 'nuget.org'
```

```plaintext
        ID Status     EnvironmentName      Ref                     CreatedAt
        -- ------     ---------------      ---                     ---------
 196679897 created    nuget.org            main         9/26/2021 5:56:57 AM
 ```

### Open Web Browser

```powershell
~/src/your-project> Get-GitlabProject |
  pipelines -Latest -Branch 'main' -Status 'success' | go
```

Opens latest successful pipeline in browser.

### Resolve Variable

`Resolve-GitlabVariable` (aka `var`) checks a project or group for a variable.  Walks up the group hierarchy until found, or no other nodes to check.
Automatically expands the value.

Example
```powershell
Get-GitlabProject | var APPLICATION_NAME
```
```text
Your application
```

 ### Get pipeline for latest deployement
 
 ```powershell
 envs -Search prod | deploys -Latest -Select Pipeline [| go]
 ```

### Deploy To Production

```powershell
~/src/your-project> pipelines -Branch 'main' -Status 'success' -Latest |
  jobs -Stage deploy -Name prod |
  Play-GitlabJob
```

### Get Pipeline Schedule

```powershell
~/src/your-project> schedule

   ID Active Description                              Cron         NextRunAt
   -- ------ -----------                              ----         ---------
 1948 True   Weekly restore for database              0 3 * * 0    9/26/2021 10:04:00 AM
 ```

## References / Acknowledgements

* [PSGitLab](https://github.com/ngetchell/PSGitLab) (now archived)
* [python-gitlab CLI documentation](https://python-gitlab.readthedocs.io/en/stable)
* [GitLab API docs](https://docs.gitlab.com/ee/api/rest/index.html)
* [powershell-yaml](https://github.com/cloudbase/powershell-yaml)
