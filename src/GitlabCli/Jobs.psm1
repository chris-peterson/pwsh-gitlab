function Get-GitlabJobs {
    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName="ByProjectId",Mandatory=$false)]
        [Parameter(ParameterSetName="ByJobId",Mandatory=$false)]
        [string]
        $ProjectId = ".",

        [Parameter(ParameterSetName="ByJobId",Mandatory=$true, Position=0)]
        [string]
        $JobId
    )
    
    $ProjectId = $(Get-GitlabProject -ProjectId $ProjectId).Id
    

    $GitlabApiArguments = @{
        HttpMethod="GET"
        Path="projects/$ProjectId/jobs/$JobId"
    }

    Invoke-GitlabApi @GitlabApiArguments | ForEach-Object { $_ | New-WrapperObject "Gitlab.Job"}
}

function Start-GitlabJob {
    [Alias("Play-GitlabJob")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = ".",

        [Parameter(Mandatory=$true, Position=0)]
        [string]
        $JobId,

        [Parameter(Mandatory=$false)]
        [switch]
        $WhatIf = $false
    )

    $ProjectId = $(Get-GitlabProject -ProjectId $ProjectId).Id
    

    $GitlabApiArguments = @{
        HttpMethod="POST"
        Path="projects/$ProjectId/jobs/$JobId"
        Whatif=$WhatIf
    }

    Invoke-GitlabApi @GitlabApiArguments | New-WrapperObject "Gitlab.GitlabJob"

}