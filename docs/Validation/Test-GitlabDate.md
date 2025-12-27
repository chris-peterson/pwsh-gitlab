---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/Validation/Test-GitlabDate.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Test-GitlabDate
---

# Test-GitlabDate

## SYNOPSIS

Validates that a string is in GitLab's expected date format (YYYY-MM-DD).

## SYNTAX

### __AllParameterSets

```
Test-GitlabDate [-DateString] <string> [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Test-GitlabDate` cmdlet validates that a date string matches the `YYYY-MM-DD` format expected by GitLab API endpoints. This function is primarily used with PowerShell's `ValidateScript` attribute to validate date parameters in other cmdlets.

## EXAMPLES

### Example 1: Validate a correct date format

```powershell
Test-GitlabDate '2024-12-25'
```

Returns `$true` because the date is in the correct format.

### Example 2: Validate an incorrect date format

```powershell
Test-GitlabDate '12/25/2024'
```

Throws an exception because the date is not in `YYYY-MM-DD` format.

### Example 3: Using in parameter validation

```powershell
param(
    [ValidateScript({ Test-GitlabDate $_ })]
    [string]$StartDate
)
```

Shows how this function is typically used as a parameter validator in other cmdlets.

## PARAMETERS

### -DateString

The date string to validate. Must be in `YYYY-MM-DD` format (e.g., `2024-12-25`).

```yaml
Type: System.String
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

Returns `$true` if the date string is valid. Throws an exception if the format is invalid.

### System.Object

See [System.Boolean](#systemboolean)

## NOTES

This function is designed for use with PowerShell's `ValidateScript` attribute. It throws an exception with a helpful message when validation fails, which PowerShell displays to the user.

## RELATED LINKS

- [GitLab API Date Format](https://docs.gitlab.com/ee/api/rest/#encoding-api-parameters-of-array-and-hash-types)
