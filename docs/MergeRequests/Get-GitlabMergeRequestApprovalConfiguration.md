---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/MergeRequests/Get-GitlabMergeRequestApprovalConfiguration
Locale: en-US
Module Name: GitlabCli
ms.date: 01/01/2026
PlatyPS schema version: 2024-05-01
title: Get-GitlabMergeRequestApprovalConfiguration
---

# Get-GitlabMergeRequestApprovalConfiguration

## SYNOPSIS

Gets the merge request approval configuration for a project.

## SYNTAX

### __AllParameterSets

```
Get-GitlabMergeRequestApprovalConfiguration [[-ProjectId] <string>] [-SiteUrl <string>]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Get-GitlabMergeRequestApprovalConfiguration` cmdlet retrieves the project-level merge request approval settings including author approval, committer approval, password requirements, and other approval-related configurations.

## EXAMPLES

### Example 1: Get approval configuration for the current project

```powershell
Get-GitlabMergeRequestApprovalConfiguration
```

Retrieves the merge request approval configuration for the current project.

### Example 2: Get approval configuration for a specific project

```powershell
Get-GitlabMergeRequestApprovalConfiguration -ProjectId 'mygroup/myproject'
```

Retrieves the merge request approval configuration for the specified project.

## PARAMETERS

### -ProjectId

The ID or URL-encoded path of the project. Defaults to the current directory's project.

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

Specifies the URL of the GitLab instance. If not specified, uses the default configured site.

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

### System.Object

See [System.Management.Automation.PSObject](#systemmanagementautomationpsobject)

### System.Management.Automation.PSObject

Returns a PSObject.

## NOTES

## RELATED LINKS

- [Update-GitlabMergeRequestApprovalConfiguration](Update-GitlabMergeRequestApprovalConfiguration.md)
- [Get-GitlabMergeRequestApprovalRule](Get-GitlabMergeRequestApprovalRule.md)
