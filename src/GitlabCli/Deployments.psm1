# https://docs.gitlab.com/ee/api/deployments.html#list-project-deployments
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
        [string]
        $UpdatedBefore,

        [Parameter(Mandatory=$false)]
        [string]
        $UpdatedAfter,

        [Parameter(Mandatory=$false)]
        [int]
        $MaxPages = 1,

        [Parameter(Mandatory=$false)]
        [switch]
        $Pipeline,

        [Parameter(Mandatory=$false)]
        [switch]
        $WhatIf
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $GitlabApiArguments = @{
        HttpMethod = 'GET'
        Path = "projects/$($Project.Id)/deployments"
        Query = @{
            sort='desc'
        }
        MaxPages = $MaxPages
    }

    if ($EnvironmentName) {
        $GitlabApiArguments.Query['environment'] = $EnvironmentName
    }
    if ($Status -and $Status -ne 'all') {
        $GitlabApiArguments.Query['status'] = $Status
    }
    if ($UpdatedBefore) {
        $GitlabApiArguments.Query['updated_before'] = $UpdatedBefore
    }
    if ($UpdatedAfter) {
        $GitlabApiArguments.Query['updated_after'] = $UpdatedAfter
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
