---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Members/Get-GitlabMembershipSortKey
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Get-GitlabMembershipSortKey
---

# Get-GitlabMembershipSortKey

## SYNOPSIS

Gets the default sort keys used for sorting membership results.

## SYNTAX

### __AllParameterSets

```
Get-GitlabMembershipSortKey [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Returns an array of sort expressions used to sort membership results. By default, members are sorted by AccessLevel in descending order (highest access first), then by Username in ascending order. This cmdlet is used internally by other member management cmdlets to provide consistent sorting.

## EXAMPLES

### Example 1: Get default sort keys

```powershell
Get-GitlabMembershipSortKey
```

Returns the sort key expressions used to sort membership results by access level (descending) then username (ascending).

## PARAMETERS

## INPUTS

## OUTPUTS

### System.Object

HIDE_ME

### System.Array

Returns an array.

## NOTES

This cmdlet is primarily used internally by other member management cmdlets such as Get-GitlabGroupMember and Get-GitlabProjectMember.

## RELATED LINKS

- [Get-GitlabGroupMember](Get-GitlabGroupMember.md)
- [Get-GitlabProjectMember](Get-GitlabProjectMember.md)
