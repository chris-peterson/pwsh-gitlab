function Resolve-GitlabVariable {

    [Alias('var')]
    [CmdletBinding(DefaultParameterSetName='FromPipeline')]
    [OutputType([string])]
    param (
        [Parameter(ParameterSetName='FromPipeline', Mandatory, ValueFromPipeline)]
        $Context,

        [Parameter(ParameterSetName='ByProject', Mandatory, ValueFromPipelineByPropertyName)]
        $ProjectId,

        [Parameter(ParameterSetName='ByGroup', Mandatory, ValueFromPipelineByPropertyName)]
        $GroupId,

        [Parameter(Mandatory=$true, Position=0)]
        [string]
        $Key,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    switch ($PSCmdlet.ParameterSetName) {
        ByProject { Get-GitlabProject $ProjectId | Resolve-GitlabVariable $Key }
        ByGroup   { Get-GitlabGroup $GroupId | Resolve-GitlabVariable $Key }
        Default   {
            Write-Verbose "checking for $Key on $($Context.psobject.TypeNames | Select-Object -First 1)..."
            if ($Context.ProjectId) {
                Write-Verbose "...project id: $($Context.ProjectId)"
                try {
                    $ProjectVar = Get-GitlabProjectVariable -ProjectId $Context.ProjectId $Key
                }
                catch {
                    if ($_.Exception.Response.StatusCode -eq 'NotFound') {
                        Write-Debug "Didn't find project variables for $($Context.ProjectId)"
                    } else {
                        Write-Warning "Error looking for project variable: $($_.Exception.Message)"
                    }
                }
                if ($ProjectVar) {
                    return $ProjectVar.Value
                } else {
                    Get-GitlabGroup $Context.Group | Resolve-GitlabVariable -Key $Key
                }
            } elseif ($Context.GroupId) {
                Write-Verbose "...group id: $($Context.GroupId)"
                try {
                    $GroupVar = Get-GitlabGroupVariable $Context.GroupId $Key
                }
                catch {
                    if ($_.Exception.Response.StatusCode.ToString() -eq 'NotFound') {
                        Write-Debug "Didn't find group variables for $($Context.GroupId)"
                    } else {
                        Write-Warning "Error looking for group variable: $($_.Exception.Message)"
                    }
                }
                Write-Verbose "...$GroupVar"
                if ($GroupVar) {
                    return $GroupVar.Value
                } else {
                    $GroupId = $Context.FullPath
                    if ($GroupId.Contains('/')) {
                        $Parent = $GroupId.Substring(0, $GroupId.LastIndexOf('/'))
                        Get-GitLabGroup -GroupId $Parent | Resolve-GitlabVariable $Key
                    }
                }
            }
        }
    }
}
function ConvertTo-GitlabVariables {
    [CmdletBinding()]
    [OutputType([hashtable[]])]
    param (
        [Parameter(ValueFromPipeline)]
        $Object,

        [Parameter()]
        [Alias('Type')]
        [string]
        $VariableType
    )

    $GitlabVars = @()
    if ($Object) {
        $Enumerator = switch ($Object.GetType().Name) {
            hashtable {
                $Object.GetEnumerator()
            }
            pscustomobject {
                $Object.PSObject.Properties
            }
            default {
                throw "Unsupported type for '-Object' (expected [hashtable] or [pscustomobject])"
            }
        }
        $Enumerator | ForEach-Object {
            $Var = @{
                key           = $_.Name
                value         = $_.Value
            }
            if ($VariableType) {
                $Var.variable_type = $VariableType
            }
            $GitlabVars += $Var
        }
    }
    ,$GitlabVars
}
