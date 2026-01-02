---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Projects/Remove-GitlabProjectTopic
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: Remove-GitlabProjectTopic
---

# Remove-GitlabProjectTopic

## SYNOPSIS

Removes one or more topics from a GitLab project.

## SYNTAX

### __AllParameterSets

```
Remove-GitlabProjectTopic [-Topic] <string[]> [-ProjectId <string>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Removes specified topics (tags) from a GitLab project. Other existing topics are preserved.

## EXAMPLES

### Example 1: Remove a single topic

```powershell
Remove-GitlabProjectTopic -Topic "deprecated"
```

Removes the "deprecated" topic from the current project.

### Example 2: Remove multiple topics

```powershell
Remove-GitlabProjectTopic -Topic "old-tag", "unused-tag"
```

Removes multiple topics from the current project.

### Example 3: Remove topics from a specific project

```powershell
Remove-GitlabProjectTopic -ProjectId "mygroup/myproject" -Topic "legacy"
```

Removes the "legacy" topic from the specified project.

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

### -ProjectId

The ID or URL-encoded path of the project. Defaults to the current directory's git repository.

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

### -Topic

One or more topic names to remove from the project.

```yaml
Type: System.String[]
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

Returns the updated GitLab project object.

### System.Object

HIDE_ME

## NOTES

This operation has a high confirmation impact.

## RELATED LINKS

- [GitLab Projects API](https://docs.gitlab.com/ee/api/projects.html)
- [Edit Project](https://docs.gitlab.com/ee/api/projects.html#edit-project)
