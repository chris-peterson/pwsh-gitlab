---
document type: cmdlet
external help file: Notes-Help.xml
HelpUri: ''
Locale: en-US
Module Name: Notes
ms.date: 09/24/2026
PlatyPS schema version: 2024-05-01
title: Remove-GitlabIssueNote
---

# Remove-GitlabIssueNote

## SYNOPSIS

Deletes a note (comment) from a GitLab issue.

## SYNTAX

### __AllParameterSets

```
Remove-GitlabIssueNote [-NoteId] <string> [-ProjectId <string>] [-IssueId <string>]
 [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Remove-GitlabIssueNote` cmdlet permanently deletes a note from a specific issue in a GitLab project. This cmdlet supports the ShouldProcess pattern, allowing you to use -WhatIf and -Confirm parameters.

## EXAMPLES

### Example 1: Delete a comment from an issue

```powershell
Remove-GitlabIssueNote -IssueId 42 -NoteId 100
```

Deletes note 100 from issue #42 in the current project context.

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

### -IssueId

The internal ID of the issue the note belongs to. This is the issue number shown in the GitLab UI (e.g., #42).

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

### -NoteId

The ID of the note to delete.

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

The ID or URL-encoded path of the project. Defaults to the current directory's git repository if not specified.

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

You can pipe a project ID and issue ID to this cmdlet.

## OUTPUTS

### System.Void

This cmdlet produces no output.

## NOTES

## RELATED LINKS

- [GitLab Notes API - Delete an issue note](https://docs.gitlab.com/ee/api/notes.html#delete-an-issue-note)
- [Get-GitlabIssueNote](../Notes/Get-GitlabIssueNote.md)
- [Update-GitlabIssueNote](../Notes/Update-GitlabIssueNote.md)
