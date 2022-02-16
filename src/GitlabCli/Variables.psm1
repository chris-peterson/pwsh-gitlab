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

    Write-Verbose "checking for $Key on $($Context.GetType().ToString()) context..."
    if ($Context.ProjectId) {
        Write-Verbose "...project id: $($Context.ProjectId)"
        try {
            $ProjectVar = Get-GitlabProjectVariable $Context.ProjectId $Key -SiteUrl $SiteUrl -WhatIf:$WhatIf
        }
        catch {
            Write-Debug $_.Exception.Message
        }
        if ($ProjectVar) {
            return $ProjectVar.Value
        } else {
            $Context = Get-GitlabGroup $Context.Group
            Resolve-GitlabVariable -Context $Context -Key $Key -SiteUrl $Site -WhatIf:$WhatIf
        }
    } elseif ($Context.GroupId) {
        Write-Verbose "...group id: $($Context.GroupId)"
        try {
            $GroupVar = Get-GitlabGroupVariable $Context.GroupId $Key -SiteUrl $SiteUrl -WhatIf:$WhatIf
        }
        catch {
            Write-Debug $_.Exception.Message
        }
        Write-Verbose "...$GroupVar"
        if ($GroupVar) {
            return $GroupVar.Value
        } else {
            $GroupId = $Context.FullPath
            if ($GroupId.Contains('/')) {
                $Parent = $GroupId.Substring(0, $GroupId.LastIndexOf('/'))
                $Context = Get-GitLabGroup -GroupId $Parent
                Resolve-GitlabVariable -Context $Context -Key $Key -SiteUrl $Site -WhatIf:$WhatIf
            }
        }
    }
}
