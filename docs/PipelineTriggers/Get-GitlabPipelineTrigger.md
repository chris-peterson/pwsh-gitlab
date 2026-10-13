---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/PipelineTriggers/Get-GitlabPipelineTrigger
Locale: en-US
Module Name: GitlabCli
ms.date: 10/13/2026
PlatyPS schema version: 2024-05-01
title: Get-GitlabPipelineTrigger
---

# Get-GitlabPipelineTrigger

## SYNOPSIS

Gets a project's pipeline trigger tokens.

## SYNTAX

### ByProjectId (Default)

```
Get-GitlabPipelineTrigger [-ProjectId <string>] [-Description <string>] [-MaxPages <uint>] [-All]
 [-SiteUrl <string>] [<CommonParameters>]
```

### ByTriggerId

```
Get-GitlabPipelineTrigger -TriggerId <int> [-ProjectId <string>] [-SiteUrl <string>]
```

## ALIASES

## DESCRIPTION

Lists the pipeline trigger tokens of a project, or gets one by ID. GitLab returns the full token only for tokens the caller created; tokens created by other users are shortened to four characters.

## EXAMPLES

### Example 1: List a project's trigger tokens

```powershell
Get-GitlabPipelineTrigger -ProjectId 'my-group/my-project'
```

Lists every trigger token on the project with its description, owner, and last use.

### Example 2: Get one trigger token

```powershell
Get-GitlabPipelineTrigger -ProjectId 'my-group/my-project' -TriggerId 12
```

Gets the trigger token with ID 12.

### Example 3: Get the newest trigger token with a description

```powershell
Get-GitlabPipelineTrigger -ProjectId 'my-group/my-project' -Description 'deploy' | Select-Object -First 1
```

## PARAMETERS

### -All

Return every page of results.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByProjectId
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Description

Return only the triggers with this description, newest first. Reads every page.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByProjectId
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

The maximum number of pages of results to return.

```yaml
Type: System.UInt32
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByProjectId
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

The ID or URL-encoded path of the project. Defaults to the project of the current directory's git remote.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: ByTriggerId
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: ByProjectId
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

The URL of the GitLab instance. If not specified, uses the default configured site.

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

### -TriggerId

The ID of the trigger token to get.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: ByTriggerId
  Position: Named
  IsRequired: true
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

The project ID, by property name.

## OUTPUTS

### Gitlab.PipelineTrigger

The trigger tokens.

## NOTES

## RELATED LINKS

- [GitLab Pipeline Trigger Tokens API](https://docs.gitlab.com/api/pipeline_triggers/)
- [New-GitlabPipelineTrigger](New-GitlabPipelineTrigger.md)
- [Remove-GitlabPipelineTrigger](Remove-GitlabPipelineTrigger.md)
