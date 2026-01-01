---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Groups/Get-GitlabGroup
Locale: en-US
Module Name: GitlabCli
ms.date: 01/01/2026
PlatyPS schema version: 2024-05-01
title: Get-GitlabGroup
---

# Get-GitlabGroup

## SYNOPSIS

Retrieves GitLab group information.

## SYNTAX

### ByGroupId (Default)

```
Get-GitlabGroup [[-GroupId] <string>] [-MaxPages <uint>] [-All] [-SiteUrl <string>]
 [<CommonParameters>]
```

### ByParentGroup

```
Get-GitlabGroup -ParentGroupId <string> [-Recurse] [-MaxPages <uint>] [-All] [-SiteUrl <string>]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Gets one or more GitLab groups. Can retrieve a specific group by ID, list subgroups of a parent group, or list all top-level groups. When using the '.' as GroupId, attempts to infer the group from the current local git directory. Groups that are marked for deletion are automatically filtered out.

## EXAMPLES

### Example 1: Get a specific group

```powershell
Get-GitlabGroup -GroupId "my-group"
```

Retrieves details about the group with the path "my-group".

### Example 2: Get subgroups of a parent group

```powershell
Get-GitlabGroup -ParentGroupId "my-org" -Recurse
```

Retrieves all descendant groups under "my-org" recursively.

### Example 3: Get group from current directory

```powershell
Get-GitlabGroup -GroupId "."
```

Infers and retrieves the group based on the current local git repository path.

## PARAMETERS

### -All

Retrieve all results by automatically paginating through all available pages.

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

The ID or URL-encoded path of the group. Use '.' to infer the group from the current local git directory.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByGroupId
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MaxPages

The maximum number of pages to retrieve. GitLab returns 20 results per page by default.

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

### -ParentGroupId

The ID or URL-encoded path of the parent group to list subgroups from.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByParentGroup
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Recurse

When used with ParentGroupId, retrieves all descendant groups recursively instead of just direct subgroups. When used without ParentGroupId, includes all groups instead of just top-level groups.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- r
ParameterSets:
- Name: ByParentGroup
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Gitlab.Group

Returns one or more GitLab group objects.

### System.Object

See [Gitlab.Group](#gitlabgroup).

## NOTES

This cmdlet automatically filters out groups that are marked for deletion.

## RELATED LINKS

- [GitLab Groups API - Details of a group](https://docs.gitlab.com/ee/api/groups.html#details-of-a-group)
- [GitLab Groups API - List groups](https://docs.gitlab.com/ee/api/groups.html#list-groups)
- [GitLab Groups API - List a group's subgroups](https://docs.gitlab.com/ee/api/groups.html#list-a-groups-subgroups)
- [GitLab Groups API - List a group's descendant groups](https://docs.gitlab.com/ee/api/groups.html#list-a-groups-descendant-groups)
