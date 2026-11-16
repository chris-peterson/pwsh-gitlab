# Helpers for rendering objects to the console without leaking secrets

<#
.SYNOPSIS
Returns a copy of an object with sensitive values redacted, for display.

.DESCRIPTION
Redacts:
- credential-like keys (authorization, token, password, secret, api_key,
  webhook, and their *_ variants, e.g. runners_token)
- a CI/CD variable's value when the variable is masked (or hidden)

Accepts hashtables, PSCustomObjects (e.g. API responses), and arrays of
either, from the pipeline or as an argument. The input is never modified.

.EXAMPLE
$Settings | Hide-GitlabSensitiveValues | ConvertTo-Json
#>
function Hide-GitlabSensitiveValues {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Redacts every sensitive value in the object')]
    [CmdletBinding()]
    [OutputType([System.Collections.Specialized.OrderedDictionary], [PSCustomObject], [object[]])]
    param(
        [Parameter(Position=0, ValueFromPipeline)]
        $InputObject
    )

    Process {
        if ($InputObject -is [System.Collections.IDictionary]) {
            $Properties = foreach ($Key in $InputObject.Keys) {
                [PSCustomObject]@{ Name = "$Key"; Value = $InputObject[$Key] }
            }
            $IsDictionary = $true
        } elseif ($InputObject -is [System.Management.Automation.PSCustomObject]) {
            # not [PSCustomObject], which is [psobject] and so also matches wrapped strings
            $Properties = $InputObject.PSObject.Properties
            $IsDictionary = $false
        } elseif ($InputObject -is [array]) {
            return , @($InputObject | ForEach-Object { Hide-GitlabSensitiveValues -InputObject $_ })
        } else {
            return $InputObject
        }

        $IsMasked = [bool]($Properties | Where-Object {
            $_.Name -in 'masked', 'hidden', 'masked_and_hidden' -and "$($_.Value)" -eq 'true'
        })

        $Copy = [ordered]@{}
        foreach ($Property in $Properties) {
            $IsSensitive = $Property.Name -match '^(.*_)?(authorization|token|password|secret|api_key|webhook)$' -or
                           ($IsMasked -and $Property.Name -eq 'value')
            if ($IsSensitive -and -not [string]::IsNullOrEmpty("$($Property.Value)")) {
                $Copy[$Property.Name] = '********'
            } else {
                $Copy[$Property.Name] = Hide-GitlabSensitiveValues -InputObject $Property.Value
            }
        }
        $IsDictionary ? $Copy : [PSCustomObject]$Copy
    }
}
