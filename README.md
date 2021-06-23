# Overview

Interact with GitLab via PowerShell

Extends (and requires) [python gitlab](https://github.com/python-gitlab/python-gitlab#python-gitlab).

You might be thinking
> Hold on, a wrapper around a wrapper around an API?

Yes!

While the GitLab API is extensive and well documented, there are some common issues that warrant a client-side "sdk" (e.g. retries on rate limit [or other transient] errors, logging, etc).

The python implementation is very well maintained and keeps up with GitLab's rapidly evolving ecosystem.  It comes with a tab-completion module which enables fast discovery and integration.

While one could use the python CLI as it is, this project adapts it to PowerShell adding higher-level functions (e.g. [`Clone-GitLabGroup`](https://github.com/chris-peterson/pwsh-gitlab#clone-gitlabgroup-aka-copy-gitlabgrouptolocalfilesystem)) as well as advanced reporting capabilities (using `Group-Object`, etc.)

## Tech Stack

![image](TechStack.png)

## Getting Started

```powershell
Install-Module -Name GitlabCli
```

## Global Switches

`-WhatIf` : For mutable operations, gives a preview of what actions would be taken.

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

## References / Acknowledgements

* [PSGitLab](https://github.com/ngetchell/PSGitLab)
* [python-gitlab CLI documentation](https://python-gitlab.readthedocs.io/en/stable/)
