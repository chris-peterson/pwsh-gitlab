# API request/response helper functions

<#
.SYNOPSIS
Renders a request or response as JSON for -WhatIf, -Confirm, and -Verbose output.

.DESCRIPTION
Builds a copy of the input in which every field named in
$global:GitlabLogSecretValues carries '(hidden)' instead of its value, then
serializes the copy. Nested hashtables, objects, and arrays are walked, so a
variable's value inside a pipeline's 'variables' array is hidden too.

Set a field to $true in $global:GitlabLogSecretValues to show its values
when debugging.

Like ConvertTo-Json, it takes its input from the pipeline and renders several
piped objects as one array.

.EXAMPLE
Write-Verbose "Request: $($Request | ConvertTo-GitlabLogText)"
#>
function ConvertTo-GitlabLogText {
    [CmdletBinding()]
    [OutputType([string])]
    param (
        [Parameter(Position=0, ValueFromPipeline)]
        $InputObject,

        [Parameter()]
        [int]
        $Depth = 10
    )

    begin {
        $Items = [Collections.Generic.List[object]]::new()
    }
    process {
        $Items.Add($InputObject)
    }
    end {
        $Value = $Items.Count -eq 1 ? $Items[0] : $Items.ToArray()
        ConvertTo-Json -InputObject (Hide-GitlabSecretValue $Value) -Depth $Depth
    }
}

function Hide-GitlabSecretValue {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Returns a copy; the input is not modified')]
    [CmdletBinding()]
    [OutputType([Collections.Specialized.OrderedDictionary])]
    [OutputType([object[]])]
    param (
        [Parameter(Position=0)]
        $InputObject
    )

    if ($null -eq $InputObject -or $InputObject -is [string] -or $InputObject -is [ValueType]) {
        return $InputObject
    }

    if ($InputObject -is [Collections.IDictionary]) {
        $Copy = [ordered]@{}
        foreach ($Key in $InputObject.Keys) {
            $Copy[$Key] = (Test-GitlabSecretField $Key) ? '(hidden)' : (Hide-GitlabSecretValue $InputObject[$Key])
        }
        return $Copy
    }

    if ($InputObject -is [Collections.IEnumerable]) {
        return ,@($InputObject | ForEach-Object { Hide-GitlabSecretValue $_ })
    }

    $Copy = [ordered]@{}
    foreach ($Property in $InputObject.PSObject.Properties) {
        $Copy[$Property.Name] = (Test-GitlabSecretField $Property.Name) ? '(hidden)' : (Hide-GitlabSecretValue $Property.Value)
    }
    $Copy
}

function Test-GitlabSecretField {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(Position=0, Mandatory)]
        [string]
        $Name
    )

    $global:GitlabLogSecretValues.Contains($Name) -and -not $global:GitlabLogSecretValues[$Name]
}

<#
.SYNOPSIS
Tests whether an error record is a GitLab API 404 (Not Found) response.

.EXAMPLE
try { Invoke-GitlabApi GET "projects/$ProjectId/variables/$Key" }
catch { if (Test-GitlabNotFound $_) { ... } else { throw } }
#>
function Test-GitlabNotFound {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(Position=0, Mandatory)]
        [Management.Automation.ErrorRecord]
        $ErrorRecord
    )

    $Response = $ErrorRecord.Exception.Response
    $null -ne $Response -and "$($Response.StatusCode)" -eq 'NotFound'
}
