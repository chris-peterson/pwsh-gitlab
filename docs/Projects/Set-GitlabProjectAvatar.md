---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Projects/Set-GitlabProjectAvatar
Locale: en-US
Module Name: GitlabCli
ms.date: 11/19/2026
PlatyPS schema version: 2024-05-01
title: Set-GitlabProjectAvatar
---

# Set-GitlabProjectAvatar

## SYNOPSIS

Sets the avatar image for a GitLab project.

## SYNTAX

### __AllParameterSets

```
Set-GitlabProjectAvatar [-Path] <string> [-ProjectId <string>] [-SiteUrl <string>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Uploads an image file or `data:` URI and sets it as the project's avatar, replacing any existing avatar. SVG images are converted to PNG before upload, since GitLab doesn't accept SVG avatars. To clear the avatar, use Remove-GitlabProjectAvatar.

## EXAMPLES

### Example 1: Set the avatar of the current project

```powershell
Set-GitlabProjectAvatar ./logo.png
```

Uploads `logo.png` as the avatar of the project for the current directory's git repository.

### Example 2: Set the avatar of a specific project

```powershell
Set-GitlabProjectAvatar -ProjectId 'mygroup/myproject' -Path ./logo.png
```

Uploads `logo.png` as the avatar of `mygroup/myproject`.

### Example 3: Set the avatar from an SVG data URI

```powershell
Set-GitlabProjectAvatar 'data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA2NCA2NCI+PHJlY3Qgd2lkdGg9IjY0IiBoZWlnaHQ9IjY0IiBmaWxsPSIjMTY3MTI1Ii8+PC9zdmc+'
```

Decodes the SVG, converts it to a 192px PNG, and uploads it as the avatar of the current project.

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
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProjectId

The ID or URL-encoded path of the project. Defaults to the current directory's git repository.

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

### Gitlab.Project

Returns the updated GitLab project object.

### System.Object

HIDE_ME

## NOTES

The image is sent as multipart form data. Requires at least the Maintainer role on the project.

## RELATED LINKS

- [GitLab Projects API - Upload a project avatar](https://docs.gitlab.com/api/projects/#upload-a-project-avatar)
- [Remove-GitlabProjectAvatar](Remove-GitlabProjectAvatar.md)
- [Update-GitlabProject](Update-GitlabProject.md)
