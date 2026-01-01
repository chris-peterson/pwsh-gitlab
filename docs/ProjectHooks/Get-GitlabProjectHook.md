---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/ProjectHooks/Get-GitlabProjectHook
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabProjectHook
---

# Get-GitlabProjectHook

## SYNOPSIS

Gets webhooks configured for a GitLab project.

## SYNTAX

### Default

```
Get-GitlabProjectHook
    [[-ProjectId] <string>]
    [-Id] <int>]
    [-SiteUrl] <string>]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves webhooks (project hooks) configured for a GitLab project. Webhooks allow external services to be notified when certain events occur in a project. You can retrieve all webhooks for a project or a specific webhook by ID.

## EXAMPLES

### Example 1: Get all webhooks for the current project

```powershell
Get-GitlabProjectHook
```

Retrieves all webhooks configured for the project in the current directory.

### Example 2: Get all webhooks for a specific project

```powershell
Get-GitlabProjectHook -ProjectId 'mygroup/myproject'
```

Retrieves all webhooks configured for the specified project.

### Example 3: Get a specific webhook by ID

```powershell
Get-GitlabProjectHook -ProjectId 'mygroup/myproject' -Id 123
```

Retrieves the webhook with ID 123 from the specified project.

## PARAMETERS

### -Id

The ID of a specific webhook to retrieve. If not specified, all webhooks for the project are returned.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases: []
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

### -ProjectId

The ID or URL-encoded path of the project. If not specified, defaults to the project in the current directory.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

You can pipe a project ID to this cmdlet.

## OUTPUTS

### Gitlab.ProjectHook

Returns one or more project hook objects containing webhook configuration details including URL, enabled events, and SSL verification settings.

### System.Object

See [Gitlab.ProjectHook](#gitlabprojecthook)

## NOTES

## RELATED LINKS

- [New-GitlabProjectHook](New-GitlabProjectHook.md)
- [Update-GitlabProjectHook](Update-GitlabProjectHook.md)
- [Remove-GitlabProjectHook](Remove-GitlabProjectHook.md)
- [GitLab Project Hooks API](https://docs.gitlab.com/ee/api/projects.html#hooks)
