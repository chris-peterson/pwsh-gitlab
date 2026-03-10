---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Tags/Remove-GitlabTag
Locale: en-US
Module Name: GitlabCli
ms.date: 03/10/2026
PlatyPS schema version: 2024-05-01
title: Remove-GitlabTag
---

# Remove-GitlabTag

## SYNOPSIS

Deletes a tag from a GitLab project repository.

## SYNTAX

### __AllParameterSets

```
Remove-GitlabTag [[-ProjectId] <string>] [-Name] <string> [[-SiteUrl] <string>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Deletes a git tag from a GitLab project repository. This is a destructive operation that cannot be undone.

## EXAMPLES

### Example 1: Delete a tag

```powershell
Remove-GitlabTag -Name 'v0.9.0'
```

Deletes the tag 'v0.9.0' from the current project.

### Example 2: Delete a tag from a specific project

```powershell
Remove-GitlabTag -ProjectId 'mygroup/myproject' -Name 'v0.9.0'
```

Deletes the tag 'v0.9.0' from the specified project.

## PARAMETERS

### -Name

The name of the tag to delete.

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
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProjectId

The ID or URL-encoded path of the project. Defaults to the current project based on local git context.

```yaml
Type: System.String
DefaultValue: .
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

### -SiteUrl

The URL of the GitLab instance. If not specified, uses the default configured GitLab site.

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

You can pipe a tag name to this cmdlet.

## OUTPUTS

### System.Object

HIDE_ME

## NOTES

## RELATED LINKS

- [GitLab Tags API](https://docs.gitlab.com/ee/api/tags.html)
