---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/ServiceAccounts/New-GitlabServiceAccount
Locale: en-US
Module Name: GitlabCli
ms.date: 01/02/2026
PlatyPS schema version: 2024-05-01
title: New-GitlabServiceAccount
---

# New-GitlabServiceAccount

## SYNOPSIS

Creates a new GitLab service account at the instance or group level.

## SYNTAX

### Instance (Default)

```
New-GitlabServiceAccount [-Name <string>] [-Username <string>] [-Email <string>] [-SiteUrl <string>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Group

```
New-GitlabServiceAccount -GroupId <string> [-Name <string>] [-Username <string>] [-Email <string>]
 [-SiteUrl <string>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Creates a new service account in GitLab. Service accounts are machine users designed for automation and CI/CD pipelines. They can be created at the instance level or within a top-level group.

## EXAMPLES

### Example 1: Create an instance service account

```powershell
New-GitlabServiceAccount -Name 'CI Bot' -Username 'ci-bot'
```

Creates a new instance-level service account with the specified name and username.

### Example 2: Create a group service account

```powershell
New-GitlabServiceAccount -GroupId 'my-group' -Name 'Deploy Bot' -Username 'deploy-bot' -Email 'deploy-bot@example.com'
```

Creates a new service account in the top-level group 'my-group'.

### Example 3: Create a service account with WhatIf

```powershell
New-GitlabServiceAccount -Name 'Test Bot' -WhatIf
```

Shows what would happen if the service account were created without actually creating it.

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

The email address for the service account.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Group
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Instance
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

The ID or URL-encoded path of the top-level group. Service accounts can only be created in top-level groups, not subgroups.

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

The display name for the service account.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Group
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Instance
  Position: Named
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

### -Username

The username for the service account.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Group
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Instance
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

## OUTPUTS

### System.Object

HIDE_ME

### Gitlab.ServiceAccount

Returns GitLab service account objects.

## NOTES

## RELATED LINKS

- [GitLab Service Accounts API](https://docs.gitlab.com/ee/api/group_service_accounts.html)
- [Get-GitlabServiceAccount](Get-GitlabServiceAccount.md)
- [Update-GitlabServiceAccount](Update-GitlabServiceAccount.md)
- [Remove-GitlabServiceAccount](Remove-GitlabServiceAccount.md)
