---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/ServiceAccounts/Update-GitlabServiceAccount
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Update-GitlabServiceAccount
---

# Update-GitlabServiceAccount

## SYNOPSIS

Updates an existing GitLab service account.

## SYNTAX

### Instance (Default)

```
Update-GitlabServiceAccount -ServiceAccountId <int> [-Name <string>] [-Username <string>]
 [-Email <string>] [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Group

```
Update-GitlabServiceAccount
    [-ServiceAccountId <int> -GroupId <string> [-Name <string>]
    [-Username <string>]
    [-Email <string>]
    [-SiteUrl <string>]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Updates the properties of an existing service account in GitLab. Can update the name, username, or email of a service account at either the instance or group level.

## EXAMPLES

### Example 1: Update a service account name

```powershell
Update-GitlabServiceAccount -ServiceAccountId 123 -Name 'Updated Bot Name'
```

Updates the display name of service account 123.

### Example 2: Update a group service account

```powershell
Update-GitlabServiceAccount -ServiceAccountId 456 -GroupId 'my-group' -Username 'new-bot-name' -Email 'new-bot@example.com'
```

Updates the username and email of a service account within a group.

### Example 3: Update service account via pipeline

```powershell
Get-GitlabServiceAccount -ServiceAccountId 123 | Update-GitlabServiceAccount -Name 'Renamed Bot'
```

Retrieves a service account and updates its name via pipeline input.

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

### -Email

The new email address for the service account.

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

### -GroupId

The ID or URL-encoded path of the group. When specified, updates a group-level service account instead of an instance-level one.

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

### -Name

The new display name for the service account.

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

### -ServiceAccountId

The ID of the service account to update.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
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

### -Username

The new username for the service account.

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

### System.Int32

The ServiceAccountId parameter accepts pipeline input by property name.

## OUTPUTS

### System.Object

See [Gitlab.ServiceAccount](#gitlabserviceaccount)

### Gitlab.ServiceAccount

Returns GitLab service account objects.

## NOTES

## RELATED LINKS

- [GitLab Service Accounts API](https://docs.gitlab.com/ee/api/group_service_accounts.html)
- [Get-GitlabServiceAccount](Get-GitlabServiceAccount.md)
- [New-GitlabServiceAccount](New-GitlabServiceAccount.md)
- [Remove-GitlabServiceAccount](Remove-GitlabServiceAccount.md)
