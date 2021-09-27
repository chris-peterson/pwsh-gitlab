function Get-GitlabDeployment {
    [CmdletBinding(DefaultParameterSetName='ProjectId')]
    [Alias('deploys')]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $EnvironmentName,

        [Parameter(Mandatory=$false)]
        [ValidateSet('created', 'running', 'success', 'failed', 'canceled', 'all')]
        [string]
        $Status = 'success',

        [Parameter(Mandatory=$false)]
        [switch]
        $Latest,

        [Parameter(Mandatory=$false)]
        [switch]
        $Pipeline,

        [Parameter(Mandatory=$false)]
        [switch]
        $WhatIf
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $GitlabApiArguments = @{
        HttpMethod='GET'
        Path="projects/$($Project.Id)/deployments"
        Query=@{
            sort='desc'
        }
    }

    if ($EnvironmentName) {
        $GitlabApiArguments.Query['environment'] = $EnvironmentName
    }
    if ($Status -and $Status -ne 'all') {
        $GitlabApiArguments.Query['status'] = $Status
    }

    $Result = Invoke-GitlabApi @GitlabApiArguments -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Deployment'

    if ($Latest) {
        $Result = $Result | Select-Object -First 1
    }
    if ($Pipeline) {
        $Result = $Result.Pipeline
    }

    $Result
}
