# API request/response helper functions

<#
.SYNOPSIS
Renders a request or response as JSON for -WhatIf, -Confirm, and -Verbose output.

.DESCRIPTION
Redacts the input with Hide-GitlabSensitiveValues (credential-like fields, and
the value of a masked, hidden, or secret-looking CI/CD variable), then
serializes the copy.

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
        ConvertTo-Json -InputObject (Hide-GitlabSensitiveValues -InputObject $Value) -Depth $Depth
    }
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
