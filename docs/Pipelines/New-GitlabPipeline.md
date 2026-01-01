---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Pipelines/New-GitlabPipeline
Locale: en-US
Module Name: GitlabCli
ms.date: 12/29/2025
PlatyPS schema version: 2024-05-01
title: New-GitlabPipeline
---

# New-GitlabPipeline

## SYNOPSIS

Creates a new pipeline in a GitLab project.

## SYNTAX

### Default

```
New-GitlabPipeline
    [[-ProjectId] <string>]
    [-Ref] <string>]
    [-Variables] <Object>]
    [-SiteUrl] <string>]
    [-Wait]
    [-Follow]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```

## ALIASES

- `build`


## DESCRIPTION

Triggers a new CI/CD pipeline in a GitLab project. By default, uses the current local branch or project's default branch. Can pass custom variables to the pipeline and optionally wait for completion with live status updates or open the pipeline in a browser.

## EXAMPLES

### Example 1: Create a pipeline on the current branch

```powershell
New-GitlabPipeline
```

Creates a new pipeline on the current local git branch.

### Example 2: Create a pipeline on a specific branch with variables

```powershell
New-GitlabPipeline -Ref 'main' -Variables @{DEPLOY_ENV='staging'; DEBUG='true'}
```

Creates a pipeline on the main branch with custom environment variables.

### Example 3: Create a pipeline and follow in browser

```powershell
New-GitlabPipeline -ProjectId 'mygroup/myproject' -Ref 'develop' -Follow
```

Creates a pipeline and opens the pipeline URL in the default browser.

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

### -Follow

Opens the pipeline URL in the default web browser after creation.

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

### -ProjectId

The ID or URL-encoded path of the project. Defaults to the project in the current directory.

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

### -Ref

The git reference (branch or tag) to run the pipeline on. Defaults to the current local branch or project's default branch.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Branch
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

### -SiteUrl

The URL of the GitLab site to connect to. Defaults to the configured default site.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Variables

A hashtable of variables to pass to the pipeline. These become environment variables available to jobs in the pipeline.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases:
- vars
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

### -Wait

Waits for the pipeline to complete, displaying live progress updates including job statuses and recent log output.

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

### Gitlab.Pipeline

Returns the created pipeline object with properties such as Id, Status, Ref, Sha, WebUrl, CreatedAt, and more. Returns nothing if -Follow is specified.

### System.Object

See [Gitlab.Pipeline](#gitlabpipeline)

## NOTES

## RELATED LINKS

- [GitLab Pipelines API - Create a new pipeline](https://docs.gitlab.com/ee/api/pipelines.html#create-a-new-pipeline)
- [Get-GitlabPipeline](Get-GitlabPipeline.md)
- [Remove-GitlabPipeline](Remove-GitlabPipeline.md)
