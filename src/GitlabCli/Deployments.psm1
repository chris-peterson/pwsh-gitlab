function Get-GitlabDeployment {
    [CmdletBinding(DefaultParameterSetName='ProjectId')]
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$false)]
        [string]
        $Environment,

        [Parameter(Mandatory=$false)]
        [ValidateSet('created', 'running', 'success', 'failed', 'canceled')]
        [string]
        $Status,

        [Parameter(Mandatory=$false)]
        [switch]
        $WhatIf
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $GitlabApiArguments = @{
        HttpMethod='GET'
        Path="projects/$($Project.Id)/deployments"
        Query=@{}
    }


    if ($Environment) {
        $GitlabApiArguments['Query']['environment'] = $Environment
    }
    if ($Status) {
        $GitlabApiArguments['Query']['status'] = $Status
    }

    Invoke-GitlabApi @GitlabApiArguments -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Deployment'
}
