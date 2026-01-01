---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Members/Get-GitlabGroupMember
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabGroupMember
---

# Get-GitlabGroupMember

## SYNOPSIS

Gets members of a GitLab group.

## SYNTAX

### Default

```
Get-GitlabGroupMember
    [[-GroupId] <string>]
    [-UserId <string>]
    [-IncludeInherited]
    [-MinAccessLevel <string>]
    [-MaxPages <uint>]
    [-All]
    [-SiteUrl <string>]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves the members of a specified GitLab group. Can return all direct members, or include inherited members from parent groups. Optionally filters by a specific user or minimum access level. Results are sorted by access level (highest first), then by username.

## EXAMPLES

### Example 1: Get members of the current group

```powershell
Get-GitlabGroupMember
```

Gets direct members of the group inferred from the current git context.

### Example 2: Get all members including inherited

```powershell
Get-GitlabGroupMember -GroupId 'mygroup' -IncludeInherited
```

Gets all members of 'mygroup', including those inherited from parent groups.

### Example 3: Get members with minimum access level

```powershell
Get-GitlabGroupMember -GroupId 'mygroup' -MinAccessLevel Maintainer
```

Gets members of 'mygroup' who have Maintainer access or higher.

## PARAMETERS

### -All

When specified, retrieves all results by automatically paginating through all available pages.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -GroupId

The ID or URL-encoded path of the group. If not specified, uses the group inferred from the current git context.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -IncludeInherited

When specified, includes members inherited from parent groups in addition to direct members.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MaxPages

The maximum number of result pages to retrieve. Use -All to retrieve all pages.

```yaml
Type: System.UInt32
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MinAccessLevel

Filter members by minimum access level. Valid values are: Guest, Reporter, Developer, Maintainer, Owner.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SiteUrl

The URL of the GitLab site to connect to. If not specified, uses the default configured site.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -UserId

The ID or username of a specific user to retrieve membership information for.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
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

### System.String

You can pipe a GroupId string to this cmdlet.

## OUTPUTS

### System.Object

See [Gitlab.Member](#gitlabmember)

### Gitlab.Member

Returns GitLab member objects.

## NOTES

Requires authentication to a GitLab instance.

## RELATED LINKS

- [GitLab Members API](https://docs.gitlab.com/ee/api/members.html)
- [Add-GitlabGroupMember](Add-GitlabGroupMember.md)
- [Set-GitlabGroupMember](Set-GitlabGroupMember.md)
- [Remove-GitlabGroupMember](Remove-GitlabGroupMember.md)
