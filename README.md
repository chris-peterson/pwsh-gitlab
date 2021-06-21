# Overview

Powershell extensions for gitlab CLI.

Extends (and requires) [python gitlab](https://github.com/python-gitlab/python-gitlab#python-gitlab).

## Getting Started

```powershell
Install-Module -Name GitlabCli
```

## Examples

### `Get-GitlabProject`

```powershell
Get-GitlabProject 'mygroup/myproject'
# OR
Get-GitlabProject 42
```

```plaintext
  ID Name        Group     Url
  -- ----        -----     ---
  42 myproject   mygroup   https://gitlab.mydomain.com/mygroup/myproject
```

## References / Acknowledgements

* [PSGitLab](https://github.com/ngetchell/PSGitLab)
