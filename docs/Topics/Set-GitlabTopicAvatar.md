---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Topics/Set-GitlabTopicAvatar
Locale: en-US
Module Name: GitlabCli
ms.date: 11/19/2026
PlatyPS schema version: 2024-05-01
title: Set-GitlabTopicAvatar
---

# Set-GitlabTopicAvatar

## SYNOPSIS

Sets the avatar image for a GitLab topic.

## SYNTAX

### __AllParameterSets

```
Set-GitlabTopicAvatar [-TopicId] <string> [-Path] <string> [-SiteUrl <string>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Uploads an image file or `data:` URI and sets it as the topic's avatar, replacing any existing avatar. SVG images are converted to PNG before upload, since GitLab doesn't accept SVG avatars. To clear the avatar, use Remove-GitlabTopicAvatar.

## EXAMPLES

### Example 1: Set the avatar of a topic

```powershell
Set-GitlabTopicAvatar 42 ./kubernetes.png
```

Uploads `kubernetes.png` as the avatar of topic 42.

### Example 2: Set the avatar of a topic found by search

```powershell
Get-GitlabTopic -Search 'kubernetes' | Set-GitlabTopicAvatar -Path ./kubernetes.png
```

Uploads `kubernetes.png` as the avatar of each matching topic.

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

### -Path

Path to the image file to upload, or a `data:` URI holding the image. Relative paths resolve against the current PowerShell location. GitLab accepts PNG, JPEG, GIF, BMP, TIFF, ICO, and WebP images up to 200 KiB. An SVG is converted to a 192px PNG first, because GitLab rejects SVG avatars; this needs `rsvg-convert` (librsvg), `magick` (ImageMagick), or, on macOS, the built-in `sips`.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: true
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

The ID of the topic. Accepts pipeline input by property name.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases:
- Id
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
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

Accepts TopicId from pipeline by property name.

## OUTPUTS

### Gitlab.Topic

Returns the updated GitLab topic object.

### System.Object

HIDE_ME

## NOTES

The image is sent as multipart form data. Requires administrator access.

## RELATED LINKS

- [GitLab Topics API - Upload a topic avatar](https://docs.gitlab.com/api/topics/#upload-a-topic-avatar)
- [Remove-GitlabTopicAvatar](Remove-GitlabTopicAvatar.md)
- [Update-GitlabTopic](Update-GitlabTopic.md)
