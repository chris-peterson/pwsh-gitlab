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

    if ($Context.ProjectId) {
        try {
            $ProjectVar = Get-GitlabProjectVariable $Context.ProjectId $Key -SiteUrl $SiteUrl -WhatIf:$WhatIf
        }
        catch {}
        if ($ProjectVar) {
            return $ProjectVar.Value
        } else {
            $Context = Get-GitlabGroup $Context.Group
            Resolve-GitlabVariable -Context $Context -Key $Key -SiteUrl $Site -WhatIf:$WhatIf
        }
    } elseif ($Context.GroupId) {
        Write-Verbose "checking for $Key on group $($Context.GroupId)..."
        try {
            $GroupVar = Get-GitlabGroupVariable $Context.GroupId $Key -SiteUrl $SiteUrl -WhatIf:$WhatIf
        }
        catch {}
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
