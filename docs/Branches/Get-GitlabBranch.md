---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Branches/Get-GitlabBranch
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Get-GitlabBranch
---

# Get-GitlabBranch

## SYNOPSIS

Gets branches from a GitLab project repository.

## SYNTAX

### Ref (Default)

```
Get-GitlabBranch [[-Ref] <string>] [-ProjectId <string>] [-MaxPages <uint>] [-All]
 [-SiteUrl <string>] [<CommonParameters>]
```

### Search

```
Get-GitlabBranch [-ProjectId <string>] [-Search <string>] [-MaxPages <uint>] [-All]
 [-SiteUrl <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves branch information from a GitLab project. Can list all branches, search for branches by name pattern, or get a specific branch by reference. Results are sorted by last updated date in descending order.

## EXAMPLES

### Example 1

```powershell
Get-GitlabBranch
```

Gets all branches from the project in the current directory.

### Example 2

```powershell
Get-GitlabBranch -ProjectId 'mygroup/myproject' -Search 'feature'
```

Searches for branches containing 'feature' in the specified project.

### Example 3

```powershell
Get-GitlabBranch -Ref 'main'
```

Gets the details of the 'main' branch from the current project.

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

### -MaxPages

The maximum number of pages to retrieve.
GitLab returns 20 results per page by default.

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

### -ProjectId

The ID or URL-encoded path of the project. Defaults to the current directory's git repository.
The ID or URL-encoded path of the project.
Defaults to the current directory's git repository.

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
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Ref

The name of the branch to retrieve.
Use '.' to get the current local branch.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Branch
ParameterSets:
- Name: Ref
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Search

Search pattern to filter branches by name.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Search
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
The URL of the GitLab site to connect to.
If not specified, uses the default configured site.

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

You can pipe a project ID to this cmdlet.

## OUTPUTS

### System.Object

HIDE_ME

### Gitlab.Branch

Returns GitLab branch objects.

## NOTES

## RELATED LINKS

- [GitLab Branches API](https://docs.gitlab.com/ee/api/branches.html)
