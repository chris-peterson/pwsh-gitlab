---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Tags/Remove-GitlabTag
Locale: en-US
Module Name: GitlabCli
ms.date: 03/14/2026
PlatyPS schema version: 2024-05-01
title: Remove-GitlabTag
---

# Remove-GitlabTag

## SYNOPSIS

Deletes a tag from a GitLab project repository.

## SYNTAX

### __AllParameterSets

```
Remove-GitlabTag [-Name] <string> [-ProjectId <string>] [-SiteUrl <string>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Deletes a repository tag from a GitLab project. This is a destructive operation and requires confirmation by default.

## EXAMPLES

### Example 1: Delete a tag

```powershell
Remove-GitlabTag -Name 'v1.0.0'
```

Deletes the tag named 'v1.0.0' from the current project after confirmation.

### Example 2: Delete a tag without confirmation

```powershell
Remove-GitlabTag -ProjectId 'mygroup/myproject' -Name 'v1.0.0-beta' -Confirm:$false
```

Deletes the tag named 'v1.0.0-beta' from the specified project without prompting for confirmation.

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

### None

This cmdlet does not produce any output.

### System.Void

This cmdlet does not produce any output.

## NOTES

## RELATED LINKS

- [GitLab Tags API](https://docs.gitlab.com/ee/api/tags.html)
