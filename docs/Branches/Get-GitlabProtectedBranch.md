---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Branches/Get-GitlabProtectedBranch
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabProtectedBranch
---

# Get-GitlabProtectedBranch

## SYNOPSIS

Gets protected branches from a GitLab project.

## SYNTAX

### Default

```
Get-GitlabProtectedBranch
    [[-ProjectId] <string>]
    [-Name] <string>]
    [-SiteUrl] <string>]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves protected branch information from a GitLab project. Can list all protected branches or get details for a specific protected branch by name.

## EXAMPLES

### Example 1

```powershell
Get-GitlabProtectedBranch
```

Gets all protected branches from the project in the current directory.

### Example 2

```powershell
Get-GitlabProtectedBranch -ProjectId 'mygroup/myproject' -Name 'main'
```

Gets the protection details for the 'main' branch in the specified project.

## PARAMETERS

### -Name

The name of the protected branch to retrieve. If not specified, all protected branches are returned.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -ProjectId

The ID or URL-encoded path of the project. Defaults to the current directory's git repository.

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
  Position: 2
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

See [Gitlab.ProtectedBranch](#gitlabprotectedbranch).

### Gitlab.ProtectedBranch

Returns GitLab protected branch objects.

## NOTES

## RELATED LINKS

- [GitLab Protected Branches API](https://docs.gitlab.com/ee/api/protected_branches.html)
