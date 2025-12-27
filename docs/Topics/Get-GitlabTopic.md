---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/Topics/Get-GitlabTopic.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabTopic
---

# Get-GitlabTopic

## SYNOPSIS

Retrieves GitLab topics.

## SYNTAX

### Search (Default)

```
Get-GitlabTopic [[-Search] <string>] [-WithoutProjects] [-MaxPages <uint>] [-All]
 [-SiteUrl <string>] [<CommonParameters>]
```

### Id

```
Get-GitlabTopic -TopicId <string> [-SiteUrl <string>] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Gets GitLab topics from the configured GitLab instance. Topics are used to categorize projects and make them easier to discover. You can retrieve all topics, search for specific topics by name, get a single topic by ID, or filter to only show topics without associated projects.

## EXAMPLES

### Example 1: Get all topics

```powershell
Get-GitlabTopic
```

Retrieves all topics from GitLab, sorted by name.

### Example 2: Search for topics

```powershell
Get-GitlabTopic -Search "devops"
```

Searches for topics containing "devops" in their name.

### Example 3: Get a specific topic by ID

```powershell
Get-GitlabTopic -TopicId 42
```

Retrieves the topic with ID 42.

## PARAMETERS

### -All

Retrieves all topics by fetching all pages of results. When specified, the MaxPages parameter is ignored.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Search
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

Specifies the maximum number of pages of results to retrieve. Used for pagination control.

```yaml
Type: System.UInt32
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Search
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Search

Searches for topics by name. Returns topics that match the search string.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Search
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SiteUrl

Specifies the URL of the GitLab instance. If not provided, uses the default configured site.

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

### -TopicId

Specifies the ID of a specific topic to retrieve.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: Id
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WithoutProjects

When specified, only retrieves topics that have no projects associated with them.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Search
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

## OUTPUTS

### Gitlab.Topic

Returns one or more GitLab topic objects containing properties such as Id, Name, Title, Description, and TotalProjectsCount.

### System.Object

See [Gitlab.Topic](#gitlabtopic)

## NOTES

## RELATED LINKS

- [GitLab Topics API](https://docs.gitlab.com/ee/api/topics.html)
- [New-GitlabTopic](New-GitlabTopic.md)
- [Update-GitlabTopic](Update-GitlabTopic.md)
- [Remove-GitlabTopic](Remove-GitlabTopic.md)
