---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Integrations/Get-GitlabProjectIntegration
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabProjectIntegration
---

# Get-GitlabProjectIntegration

## SYNOPSIS

Gets integration settings for a GitLab project.

## SYNTAX

### Default

```
Get-GitlabProjectIntegration
    [[-Integration] <string>]
    [-ProjectId <string>]
    [-SiteUrl <string>]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves a list of all active integrations for a project, or gets the settings for a specific integration. Integrations allow GitLab projects to interact with external services such as Slack, Jira, Jenkins, and many others.

## EXAMPLES

### Example 1

```powershell
Get-GitlabProjectIntegration
```

Gets all active integrations for the project in the current directory.

### Example 2

```powershell
Get-GitlabProjectIntegration -ProjectId 'mygroup/myproject' -Integration 'slack'
```

Gets the Slack integration settings for the specified project.

### Example 3

```powershell
Get-GitlabProjectIntegration -Integration 'jira'
```

Gets the Jira integration settings for the project in the current directory.

## PARAMETERS

### -Integration

The name of the specific integration to retrieve. If not specified, returns all active integrations. Valid values include: assana, assembla, bamboo, bugzilla, buildkite, campfire, datadog, discord, drone-ci, emails-on-push, github, jira, slack, gitlab-slack-application, microsoft-teams, mattermost, teamcity, jenkins, and many others.

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
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProjectId

The ID or URL-encoded path of the project. If not specified, uses the project in the current directory.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

You can pipe a project ID to this cmdlet.

## OUTPUTS

### Gitlab.ProjectIntegration

Returns one or more project integration objects containing integration settings and configuration.

### System.Object

See [Gitlab.ProjectIntegration](#gitlabprojectintegration).

## NOTES

Corresponds to the GitLab API endpoint: GET /projects/:id/integrations

## RELATED LINKS

- [Update-GitlabProjectIntegration](Update-GitlabProjectIntegration.md)
- [Remove-GitlabProjectIntegration](Remove-GitlabProjectIntegration.md)
- [Enable-GitlabProjectSlackNotification](Enable-GitlabProjectSlackNotification.md)
- [GitLab Integrations API](https://docs.gitlab.com/ee/api/integrations.html)
