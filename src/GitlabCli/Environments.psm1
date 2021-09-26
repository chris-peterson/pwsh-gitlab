function Get-GitlabEnvironment {
    [CmdletBinding(DefaultParameterSetName='ProjectId')]
    param (
        [Parameter(ParameterSetName='ProjectId', Mandatory=$false)]
        [string]
        $ProjectId = '.',

        [Parameter(ParameterSetName='Name', Mandatory=$true)]
        [string]
        $Name,

        [Parameter(ParameterSetName='Search', Mandatory=$true)]
        [string]
        $Search,

        [Parameter(Mandatory=$false)]
        [switch]
        $WhatIf
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $GitlabApiArguments = @{
        HttpMethod='GET'
        Path="projects/$($Project.Id)/environments"
        Query=@{}
    }

    switch($PSCmdlet.ParameterSetName) {
        Name {
            $GitlabApiArguments['Query']['name'] = $Name
        }
        Search {
            $GitlabApiArguments['Query']['search'] = $Search
        }
    }

    Invoke-GitlabApi @GitlabApiArguments -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Environment'
}
