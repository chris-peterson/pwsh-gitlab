---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Members/Get-GitlabUserMembership
Locale: en-US
Module Name: GitlabCli
ms.date: 12/29/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabUserMembership
---

# Get-GitlabUserMembership

## SYNOPSIS

Gets all group and project memberships for a GitLab user.

## SYNTAX

### ByUsername (Default)

```
Get-GitlabUserMembership [-Username] <string> [-SiteUrl <string>] [-MaxPages <uint>] [-All]
 [<CommonParameters>]
```

### Me

```
Get-GitlabUserMembership
    [-Me]
    [-SiteUrl <string>]
    [-MaxPages <uint>]
    [-All]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves all groups and projects that a specified user is a member of. This cmdlet requires admin access to query another user's memberships. Use the -Me parameter to get your own memberships without admin access.

## EXAMPLES

### Example 1: Get your own memberships

```powershell
Get-GitlabUserMembership -Me
```

Returns all groups and projects you are a member of.

### Example 2: Get memberships for a specific user

```powershell
Get-GitlabUserMembership -Username 'jsmith'
```

Returns all groups and projects that user 'jsmith' is a member of. Requires admin access.

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

### -Me

When specified, retrieves memberships for the currently authenticated user.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Me
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

### -Username

The username of the user whose memberships to retrieve. Requires admin access.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByUsername
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
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

You can pipe a Username string to this cmdlet.

## OUTPUTS

### System.Object

See [Gitlab.UserMembership](#gitlabusermembership)

### Gitlab.UserMembership

Returns GitLab user membership objects.

## NOTES

Querying another user's memberships requires admin access. Use -Me to retrieve your own memberships without admin access.

## RELATED LINKS

- [GitLab Users API - User memberships (admin only)](https://docs.gitlab.com/ee/api/users.html#user-memberships-admin-only)
- [Add-GitlabUserMembership](Add-GitlabUserMembership.md)
- [Remove-GitlabUserMembership](Remove-GitlabUserMembership.md)
- [Update-GitlabUserMembership](Update-GitlabUserMembership.md)
