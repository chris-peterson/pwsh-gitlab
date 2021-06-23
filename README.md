# Overview

Powershell extensions for gitlab CLI.

Extends (and requires) [python gitlab](https://github.com/python-gitlab/python-gitlab#python-gitlab).

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

#### `Clone-GitLabGroup` (aka `Copy-GitLabGroupToLocalFileSystem`)

```powershell
Clone-GitLabGroup 'mygroup'
```

### Projects

#### `Get-GitLabProject` (By Project ID)

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

#### `Get-GitLabProject` (By Group ID)

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

`-IncludeArchived` - Set this switch to include archived projects.

## References / Acknowledgements

* [PSGitLab](https://github.com/ngetchell/PSGitLab)
