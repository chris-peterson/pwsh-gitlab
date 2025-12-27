---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://github.com/chris-peterson/pwsh-gitlab/blob/main/docs/ServiceAccounts/Get-GitlabServiceAccount.md
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabServiceAccount
---

# Get-GitlabServiceAccount

## SYNOPSIS

Retrieves GitLab service accounts at the instance or group level.

## SYNTAX

### Instance (Default)

```
Get-GitlabServiceAccount [[-ServiceAccountId] <int>] [-SiteUrl <string>] [-MaxPages <uint>] [-All]
 [<CommonParameters>]
```

### Group

```
Get-GitlabServiceAccount [[-ServiceAccountId] <int>] -GroupId <string> [-SiteUrl <string>]
 [-MaxPages <uint>] [-All] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Retrieves service accounts from GitLab. Service accounts are machine users designed for automation and CI/CD pipelines. Can retrieve all service accounts or filter by a specific ID, at either the instance or group level.

## EXAMPLES

### Example 1: Get all instance service accounts

```powershell
Get-GitlabServiceAccount
```

Retrieves all service accounts at the instance level.

### Example 2: Get a specific service account by ID

```powershell
Get-GitlabServiceAccount -ServiceAccountId 123
```

Retrieves the service account with ID 123.

### Example 3: Get all service accounts for a group

```powershell
Get-GitlabServiceAccount -GroupId 'my-group' -All
```

Retrieves all service accounts associated with 'my-group'.

## PARAMETERS

### -All

Return all results by automatically paginating through all pages.

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

### -GroupId

The ID or URL-encoded path of the group. When specified, retrieves service accounts at the group level instead of instance level.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Group
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MaxPages

The maximum number of result pages to retrieve.

```yaml
Type: System.UInt32
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

### -ServiceAccountId

The ID of a specific service account to retrieve.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: Group
  Position: 0
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Instance
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Object

See [Gitlab.ServiceAccount](#gitlabserviceaccount)

### Gitlab.ServiceAccount

Returns GitLab service account objects.

## NOTES

## RELATED LINKS

- [GitLab Service Accounts API](https://docs.gitlab.com/ee/api/group_service_accounts.html)
- [New-GitlabServiceAccount](New-GitlabServiceAccount.md)
- [Update-GitlabServiceAccount](Update-GitlabServiceAccount.md)
- [Remove-GitlabServiceAccount](Remove-GitlabServiceAccount.md)
