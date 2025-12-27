---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/Members/Get-GitlabProjectMember.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabProjectMember
---

# Get-GitlabProjectMember

## SYNOPSIS

Gets members of a GitLab project.

## SYNTAX

### __AllParameterSets

```
Get-GitlabProjectMember [[-ProjectId] <string>] [[-UserId] <string>] [[-MaxPages] <uint>]
 [[-SiteUrl] <string>] [-IncludeInherited] [-All] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves the members of a specified GitLab project. Can return all direct members, or include inherited members from parent groups. Optionally filters by a specific user. Results are sorted by access level (highest first), then by username.

## EXAMPLES

### Example 1: Get members of the current project

```powershell
Get-GitlabProjectMember
```

Gets direct members of the project inferred from the current git context.

### Example 2: Get all members including inherited

```powershell
Get-GitlabProjectMember -ProjectId 'mygroup/myproject' -IncludeInherited
```

Gets all members of 'mygroup/myproject', including those inherited from parent groups.

### Example 3: Get a specific user's membership

```powershell
Get-GitlabProjectMember -ProjectId 'mygroup/myproject' -UserId 'jsmith'
```

Gets the membership information for user 'jsmith' in the specified project.

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
  Position: 2
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProjectId

The ID or URL-encoded path of the project. If not specified, uses the project inferred from the current git context.

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

### -SiteUrl

The URL of the GitLab site to connect to. If not specified, uses the default configured site.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -UserId

The ID or username of a specific user to retrieve membership information for. Alias: Username.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Username
ParameterSets:
- Name: (All)
  Position: 1
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

You can pipe a ProjectId string to this cmdlet.

## OUTPUTS

### System.Object

See [Gitlab.Member](#gitlabmember)

### Gitlab.Member

Returns GitLab member objects.

## NOTES

Requires authentication to a GitLab instance.

## RELATED LINKS

- [GitLab Members API](https://docs.gitlab.com/ee/api/members.html)
- [Add-GitlabProjectMember](Add-GitlabProjectMember.md)
- [Set-GitlabProjectMember](Set-GitlabProjectMember.md)
- [Remove-GitlabProjectMember](Remove-GitlabProjectMember.md)
