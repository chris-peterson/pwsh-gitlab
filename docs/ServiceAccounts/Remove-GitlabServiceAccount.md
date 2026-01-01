---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/ServiceAccounts/Remove-GitlabServiceAccount
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Remove-GitlabServiceAccount
---

# Remove-GitlabServiceAccount

## SYNOPSIS

Deletes a GitLab group service account.

## SYNTAX

### Instance (Default)

```
Remove-GitlabServiceAccount [-ServiceAccountId] <int> [-SiteUrl <string>] [-Force] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Group

```
Remove-GitlabServiceAccount
    [-ServiceAccountId] <int> -GroupId <string> [-SiteUrl <string>]
    [-Force]
    [-WhatIf]
    [-Confirm]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Deletes a service account from GitLab. Currently only supports deleting group-level service accounts. For instance-level service accounts, use Remove-GitlabUser instead.

## EXAMPLES

### Example 1: Remove a group service account

```powershell
Remove-GitlabServiceAccount -ServiceAccountId 123 -GroupId 'my-group'
```

Deletes service account 123 from the group 'my-group' after confirmation.

### Example 2: Force remove without confirmation

```powershell
Remove-GitlabServiceAccount -ServiceAccountId 456 -GroupId 'my-group' -Force
```

Deletes the service account without prompting for confirmation.

### Example 3: Remove via pipeline

```powershell
Get-GitlabServiceAccount -GroupId 'my-group' | Where-Object Name -like '*test*' | Remove-GitlabServiceAccount -GroupId 'my-group'
```

Removes all service accounts in 'my-group' with 'test' in their name.

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

### -Force

Skips the confirmation prompt and immediately deletes the service account.

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

The ID or URL-encoded path of the group containing the service account. Required for group-level service accounts.

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

### -ServiceAccountId

The ID of the service account to delete.

```yaml
Type: System.Int32
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: Group
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
- Name: Instance
  Position: 0
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

See [System.Void](#systemvoid)

### System.Void

N/A

## NOTES

## RELATED LINKS

- [GitLab Service Accounts API](https://docs.gitlab.com/ee/api/group_service_accounts.html)
- [Get-GitlabServiceAccount](Get-GitlabServiceAccount.md)
- [New-GitlabServiceAccount](New-GitlabServiceAccount.md)
- [Update-GitlabServiceAccount](Update-GitlabServiceAccount.md)
