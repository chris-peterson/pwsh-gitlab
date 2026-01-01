---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Jobs/Get-GitlabJobArtifact
Locale: en-US
Module Name: GitlabCli
ms.date: 12/27/2025
PlatyPS schema version: 2024-05-01
title: Get-GitlabJobArtifact
---

# Get-GitlabJobArtifact

## SYNOPSIS

Downloads job artifacts from a GitLab CI/CD job.

## SYNTAX

### Default

```
Get-GitlabJobArtifact
    [-JobId] <string> [[-ProjectId] <string>]
    [-ArtifactPath] <string>]
    [-OutFile] <string> [[-SiteUrl] <string>]
    [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

Downloads artifacts from a GitLab CI/CD job to a local file. Can download the entire artifacts archive or a specific file within the archive by specifying the artifact path.

## EXAMPLES

### Example 1

```powershell
Get-GitlabJobArtifact -JobId 12345 -OutFile './artifacts.zip'
```

Downloads all artifacts from job 12345 to a local zip file.

### Example 2

```powershell
Get-GitlabJobArtifact -JobId 12345 -ArtifactPath 'coverage/report.html' -OutFile './report.html'
```

Downloads a specific file from the job artifacts.

## PARAMETERS

### -ArtifactPath

The path to a specific file within the job artifacts to download. If not specified, downloads the entire artifacts archive.

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

### -JobId

The ID of the job to download artifacts from.

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
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OutFile

The local file path where the downloaded artifact(s) will be saved.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 3
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ProjectId

The ID or URL-encoded path of the project. Defaults to the current directory's Git remote.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: true
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -SiteUrl

The URL of the GitLab site. If not specified, uses the default configured site.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 4
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

Accepts JobId and ProjectId from the pipeline by property name.

## OUTPUTS

### None

This cmdlet downloads a file to disk and does not return output to the pipeline.

### System.Object

See [System.Void](#systemvoid)

### System.Void

N/A

## NOTES

The artifacts must have been uploaded by the job during pipeline execution.

## RELATED LINKS

- [GitLab Jobs API - Download Artifacts](https://docs.gitlab.com/ee/api/jobs.html#download-a-single-artifact-file-from-specific-tag-or-branch)
- [Get-GitlabJob](Get-GitlabJob.md)
