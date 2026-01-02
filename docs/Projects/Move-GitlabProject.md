---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Projects/Move-GitlabProject
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Move-GitlabProject
---

# Move-GitlabProject

## SYNOPSIS

Transfers a GitLab project to a different namespace (group).

## SYNTAX

### __AllParameterSets

```
Move-GitlabProject [[-ProjectId] <string>] [-DestinationGroup] <string> [[-SiteUrl] <string>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

- `Transfer-GitlabProject`


## DESCRIPTION

Transfers a project to a new namespace (group). This operation changes the project's path and URL. You must have at least maintainer access to the project and owner access to the destination group.

## EXAMPLES

### Example 1: Move a project to a different group

```powershell
Move-GitlabProject -ProjectId "oldgroup/myproject" -DestinationGroup "newgroup"
```

Transfers the project "myproject" from "oldgroup" to "newgroup".

### Example 2: Move the current project

```powershell
Move-GitlabProject -DestinationGroup "newgroup"
```

Transfers the current directory's project to "newgroup".

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
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

### -DestinationGroup

The ID or URL-encoded path of the destination group to transfer the project to.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: true
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

### -WhatIf

Runs the command in a mode that only reports what would happen without performing the actions.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
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

### Gitlab.Project

Returns the transferred GitLab project object.

### System.Object

HIDE_ME

## NOTES

This cmdlet has an alias: Transfer-GitlabProject.

## RELATED LINKS

- [GitLab Projects API](https://docs.gitlab.com/ee/api/projects.html)
- [Transfer a Project](https://docs.gitlab.com/ee/api/projects.html#transfer-a-project-to-a-new-namespace)
