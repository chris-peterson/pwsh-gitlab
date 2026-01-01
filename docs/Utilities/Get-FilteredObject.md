---
document type: cmdlet
external help file: GitlabCli-Help.xml
HelpUri: https://chris-peterson.github.io/pwsh-gitlab/#/Utilities/Get-FilteredObject
Locale: en-US
Module Name: GitlabCli
ms.date: 01/01/2026
PlatyPS schema version: 2024-05-01
title: Get-FilteredObject
---

# Get-FilteredObject

## SYNOPSIS

Filters and selects properties from input objects.

## SYNTAX

### __AllParameterSets

```
Get-FilteredObject [[-Select] <string>] -InputObject <Object> [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

The `Get-FilteredObject` cmdlet filters objects by selecting specific properties. It can return the entire object (default), a single expanded property, or multiple selected properties. This is a utility function used throughout the GitlabCli module to provide consistent property selection behavior.

## EXAMPLES

### Example 1: Return all properties

```powershell
Get-GitlabProject 'mygroup/myproject' | Get-FilteredObject
```

Returns the complete project object with all properties.

### Example 2: Select a single property and expand it

```powershell
Get-GitlabProject 'mygroup/myproject' | Get-FilteredObject 'Name'
```

Returns only the value of the `Name` property (expanded, not wrapped in an object).

### Example 3: Select multiple properties

```powershell
Get-GitlabProject 'mygroup/myproject' | Get-FilteredObject 'Name,Id,WebUrl'
```

Returns an object containing only the `Name`, `Id`, and `WebUrl` properties.

## PARAMETERS

### -InputObject

The object(s) to filter. This parameter accepts pipeline input, allowing you to pipe GitLab objects directly to this cmdlet.

```yaml
Type: System.Object
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: true
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Select

Specifies which properties to return. Use `*` to return all properties (default), a single property name to expand and return just that value, or a comma-separated list of property names to return an object with those properties.

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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

Accepts any object from the pipeline.

## OUTPUTS

### System.Object

See [System.Management.Automation.PSObject](#systemmanagementautomationpsobject)

### System.Management.Automation.PSObject

Returns a PSObject.

## NOTES

This is a utility function used internally by many GitlabCli cmdlets to provide the `-Select` parameter functionality.

## RELATED LINKS

- [Get-GitlabVersion](Get-GitlabVersion.md)
