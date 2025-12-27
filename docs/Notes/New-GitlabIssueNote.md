---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/Notes/New-GitlabIssueNote.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: New-GitlabIssueNote
---

# New-GitlabIssueNote

## SYNOPSIS

Creates a new note (comment) on a GitLab issue.

## SYNTAX

### __AllParameterSets

```
New-GitlabIssueNote [-Note] <string> [-ProjectId <string>] [-IssueId <string>] [-SiteUrl <string>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `New-GitlabIssueNote` cmdlet creates a new note (comment) on a specific issue in a GitLab project. This cmdlet supports the ShouldProcess pattern, allowing you to use -WhatIf and -Confirm parameters. An alias `Add-GitlabIssueNote` is also available.

## EXAMPLES

### Example 1: Add a comment to an issue

```powershell
New-GitlabIssueNote -IssueId 42 -Note 'This issue has been triaged.'
```

Adds a comment to issue #42 in the current project context.

### Example 2: Add a comment to an issue in a specific project

```powershell
New-GitlabIssueNote -ProjectId 'mygroup/myproject' -IssueId 15 -Note 'Working on this now.'
```

Adds a comment to issue #15 in the specified project.

### Example 3: Use the alias and preview changes

```powershell
Add-GitlabIssueNote -IssueId 42 -Note 'Closing as duplicate' -WhatIf
```

Previews what would happen without actually creating the note.

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

The internal ID of the issue to add the note to. This is the issue number shown in the GitLab UI (e.g., #42).

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

### -Note

The body text of the note to create. Supports GitLab Flavored Markdown.

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

### Gitlab.Note

Returns the newly created note object containing the note body, author, creation date, and other metadata.

### System.Object

See [Gitlab.Note](#gitlabnote)

## NOTES

## RELATED LINKS

- [GitLab Notes API - Create new issue note](https://docs.gitlab.com/ee/api/notes.html#create-new-issue-note)
- [Get-GitlabIssueNote](Get-GitlabIssueNote.md)
