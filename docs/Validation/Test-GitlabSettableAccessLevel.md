---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/Validation/Test-GitlabSettableAccessLevel.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Test-GitlabSettableAccessLevel
---

# Test-GitlabSettableAccessLevel

## SYNOPSIS

Validates that a permission level can be set on GitLab resources.

## SYNTAX

### __AllParameterSets

```
Test-GitlabSettableAccessLevel [-Permission] <Object> [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Test-GitlabSettableAccessLevel` cmdlet validates that a permission value is one of the settable GitLab access levels. It accepts both string names (`guest`, `reporter`, `developer`, `maintainer`, `owner`) and their numeric equivalents (10, 20, 30, 40, 50). This function is primarily used with PowerShell's `ValidateScript` attribute.

## EXAMPLES

### Example 1: Validate a string access level

```powershell
Test-GitlabSettableAccessLevel 'developer'
```

Returns `$true` because `developer` is a valid settable access level.

### Example 2: Validate a numeric access level

```powershell
Test-GitlabSettableAccessLevel 30
```

Returns `$true` because `30` corresponds to the `developer` access level.

### Example 3: Test an invalid access level

```powershell
Test-GitlabSettableAccessLevel 'admin'
```

Returns `$false` because `admin` is not a settable access level.

## PARAMETERS

### -Permission

The access level to validate. Can be a string (`guest`, `reporter`, `developer`, `maintainer`, `owner`) or numeric value (10, 20, 30, 40, 50).

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Boolean

Returns `$true` if the permission is a valid settable access level, `$false` otherwise.

### System.Object

See [System.Boolean](#systemboolean)

## NOTES

The settable access levels are: `guest` (10), `reporter` (20), `developer` (30), `maintainer` (40), and `owner` (50). Note that `owner` is only available for groups, not projects.

## RELATED LINKS

- [GitLab Permissions and Roles](https://docs.gitlab.com/ee/user/permissions.html)
- [GitLab Members API](https://docs.gitlab.com/ee/api/members.html)
