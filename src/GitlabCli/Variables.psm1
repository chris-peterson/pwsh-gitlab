function Resolve-GitlabVariable {

    [Alias('var')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $Context,

        [Parameter(Mandatory=$true, Position=0)]
        [string]
        $Key,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    Write-Verbose "checking for $Key on $($Context.psobject.TypeNames | Select-Object -First 1)..."
    if ($Context.ProjectId) {
        Write-Verbose "...project id: $($Context.ProjectId)"
        try {
            $ProjectVar = Get-GitlabProjectVariable -ProjectId $Context.ProjectId $Key -SiteUrl $SiteUrl -WhatIf:$WhatIf
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
            Get-GitlabGroup $Context.Group | Resolve-GitlabVariable -Key $Key -SiteUrl $Site -WhatIf:$WhatIf
        }
    } elseif ($Context.GroupId) {
        Write-Verbose "...group id: $($Context.GroupId)"
        try {
            $GroupVar = Get-GitlabGroupVariable $Context.GroupId $Key -SiteUrl $SiteUrl -WhatIf:$WhatIf
        }
        catch {
            if ($_.Exception.Response.StatusCode -eq 'NotFound') {
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
                Get-GitLabGroup -GroupId $Parent | Resolve-GitlabVariable $Key -SiteUrl $Site -WhatIf:$WhatIf
            }
        }
    }
}
