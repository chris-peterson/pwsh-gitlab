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

    Invoke-GitlabApi @GitlabApiArguments | New-WrapperObject "Gitlab.Job"
}

function Start-GitlabJob {
    [Alias("Play-GitlabJob")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipelineByPropertyName=$true)]
        [Alias('Id')]
        [string]
        $JobId,

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$false)]
        [switch]
        $WhatIf = $false
    )

    $ProjectId = $(Get-GitlabProject -ProjectId $ProjectId).Id

    $GitlabApiArguments = @{
        HttpMethod="POST"
        Path="projects/$ProjectId/jobs/$JobId/play"
    }

    try {
        Invoke-GitlabApi @GitlabApiArguments -WhatIf:$WhatIf | New-WrapperObject "Gitlab.PipelineJob"
    }
    catch {
        if ($_.ErrorDetails.Message -match 'Unplayable Job') {
            $GitlabApiArguments.Path = $GitlabApiArguments.Path -replace '/play', '/retry'
            Invoke-GitlabApi @GitlabApiArguments -WhatIf:$WhatIf | New-WrapperObject "Gitlab.PipelineJob"
        }
    }
}