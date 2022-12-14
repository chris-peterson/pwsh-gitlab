function Resolve-GitlabVariable {

    [Alias('var')]
    [CmdletBinding(DefaultParameterSetName='FromPipeline')]
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
        ByProject { Get-GitlabProject $ProjectId | Resolve-GitlabVariable $Key -SiteUrl $SiteUrl }
        ByGroup   { Get-GitlabGroup $GroupId | Resolve-GitlabVariable $Key -SiteUrl $SiteUrl }
        Default   {
            Write-Verbose "checking for $Key on $($Context.psobject.TypeNames | Select-Object -First 1)..."
            if ($Context.ProjectId) {
                Write-Verbose "...project id: $($Context.ProjectId)"
                try {
                    $ProjectVar = Get-GitlabProjectVariable -ProjectId $Context.ProjectId $Key -SiteUrl $SiteUrl
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
                    Get-GitlabGroup $Context.Group | Resolve-GitlabVariable -Key $Key -SiteUrl $SiteUrl
                }
            } elseif ($Context.GroupId) {
                Write-Verbose "...group id: $($Context.GroupId)"
                try {
                    $GroupVar = Get-GitlabGroupVariable $Context.GroupId $Key -SiteUrl $SiteUrl
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
                        Get-GitLabGroup -GroupId $Parent | Resolve-GitlabVariable $Key -SiteUrl $SiteUrl
                    }
                }
            }
        }
    }
}
