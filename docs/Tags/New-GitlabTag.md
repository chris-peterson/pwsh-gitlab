---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Tags/New-GitlabTag
Locale: en-US
Module Name: GitlabCli
ms.date: 03/10/2026
PlatyPS schema version: 2024-05-01
title: New-GitlabTag
---

# New-GitlabTag

## SYNOPSIS

Creates a new tag in a GitLab project repository.

## SYNTAX

### __AllParameterSets

```
New-GitlabTag [[-ProjectId] <string>] [-Name] <string> -Ref <string> [[-Message] <string>]
 [[-SiteUrl] <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Creates a new git tag in a GitLab project repository. The tag can be created from any branch, commit SHA, or other tag. An optional message can be provided to create an annotated tag.

## EXAMPLES

### Example 1: Create a lightweight tag

```powershell
New-GitlabTag -Name 'v1.0.0' -Ref 'main'
```

Creates a tag named 'v1.0.0' pointing to the main branch in the current project.

### Example 2: Create an annotated tag

```powershell
New-GitlabTag -ProjectId 'mygroup/myproject' -Name 'v2.0.0' -Ref 'abc123' -Message 'Release version 2.0.0'
```

Creates an annotated tag with a message from a specific commit SHA.

## PARAMETERS

### -Message

An optional message for the tag. When provided, creates an annotated tag.

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

### -Name

The name of the tag to create.

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

### -Ref

The branch name or commit SHA to create the tag from.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Branch
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
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

You can pipe a project ID to this cmdlet.

## OUTPUTS

### Gitlab.Tag

Returns the newly created GitLab tag object.

### System.Object

HIDE_ME

## NOTES

## RELATED LINKS

- [GitLab Tags API](https://docs.gitlab.com/ee/api/tags.html)
