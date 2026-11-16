# Helpers for rendering objects to the console without leaking secrets

<#
.SYNOPSIS
Returns a copy of an object with sensitive values redacted, for display.

.DESCRIPTION
Redacts:
- credential-like keys (authorization, token, password, secret, api_key,
  webhook, and their *_ variants, e.g. runners_token)
- a CI/CD variable's value when the variable is masked (or hidden), or
  when its key looks like a secret (e.g. DEPLOY_TOKEN, DB_PASSWORD)

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

        $IsSensitiveVariable = Test-GitlabSensitiveVariable $Properties

        $Copy = [ordered]@{}
        foreach ($Property in $Properties) {
            $IsSensitive = $Property.Name -match '^(.*_)?(authorization|token|password|secret|api_key|webhook)$' -or
                           ($IsSensitiveVariable -and $Property.Name -eq 'value')
            if ($IsSensitive -and -not [string]::IsNullOrEmpty("$($Property.Value)")) {
                $Copy[$Property.Name] = '********'
            } else {
                $Copy[$Property.Name] = Hide-GitlabSensitiveValues -InputObject $Property.Value
            }
        }
        $IsDictionary ? $Copy : [PSCustomObject]$Copy
    }
}

<#
.SYNOPSIS
Returns true when a CI/CD variable's value is a secret.

.DESCRIPTION
A variable is sensitive when it's masked or hidden, or when its key looks
like a secret (contains TOKEN, SECRET, PASSWORD, PASSWD, KEY, CREDENTIAL,
or PRIVATE). The key test leans broad: hiding a harmless value costs a
.Value lookup, while a printed secret can't be recalled.

Takes the variable's properties (name/value pairs), so it reads API
responses (masked, key) and module objects (Masked, Key) alike.
#>
function Test-GitlabSensitiveVariable {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Position=0)]
        $Properties
    )

    [bool]($Properties | Where-Object {
        ($_.Name -in 'masked', 'hidden', 'masked_and_hidden' -and "$($_.Value)" -eq 'true') -or
        ($_.Name -eq 'key' -and "$($_.Value)" -match 'TOKEN|SECRET|PASSWORD|PASSWD|KEY|CREDENTIAL|PRIVATE')
    })
}

<#
.SYNOPSIS
Adds a Display<Name> property: the named property's value, or ******** when
the variable is sensitive.

.DESCRIPTION
Table views show Display<Name> in place of <Name>, so a secret never reaches
the console by default. <Name> keeps the real value for callers that ask for
it. The alias is a ScriptProperty, so the sensitivity test runs only when
something reads it.
#>
function Add-GitlabDisplayProperty {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        $InputObject,

        [Parameter(Mandatory)]
        [string]
        $Name
    )

    Process {
        # the getter runs wherever the object is read, outside this module's
        # scope, so it carries the test with it rather than calling it by name
        $IsSensitive = ${function:Test-GitlabSensitiveVariable}
        $Getter = {
            $Value = $this.$Name
            $Properties = $this.PSObject.Properties.Match('*', 'NoteProperty')
            ((& $IsSensitive $Properties) -and -not [string]::IsNullOrEmpty("$Value")) ? '********' : $Value
        }.GetNewClosure()
        $InputObject | Add-Member -MemberType ScriptProperty -Name "Display$Name" -Value $Getter -Force
    }
}
