function Get-GitlabEnvironment {
    [CmdletBinding(DefaultParameterSetName='List')]
    [Alias('envs')]
    param (
        [Parameter(Mandatory=$false)]
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
        $IncludeStopped,

        [Parameter(Mandatory=$false)]
        [int]
        $MaxPages = 1,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $GitlabApiArguments = @{
        HttpMethod='GET'
        Path="projects/$($Project.Id)/environments"
        Query=@{}
        SiteUrl = $SiteUrl
        MaxPages = $MaxPages
    }

    switch ($PSCmdlet.ParameterSetName) {
        Name {
            $GitlabApiArguments.Query['name'] = $Name
        }
        Search {
            $GitlabApiArguments.Query['search'] = $Search
        }
    }

    if ((-not $IncludeStopped) -and (-not $Name)) {
        $GitlabApiArguments.Query['states'] = 'available'
    }

    Invoke-GitlabApi @GitlabApiArguments -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Environment'
}

function Stop-GitlabEnvironment {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $Name,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    process {
        $Project = Get-GitlabProject -ProjectId $ProjectId
        $Environment = Get-GitlabEnvironment -ProjectId $Project.Id -Name $Name
    
        $GitlabApiArguments = @{
            HttpMethod='POST'
            Path="projects/$($Project.Id)/environments/$($Environment.Id)/stop"
            SiteUrl = $SiteUrl
        }
    
        Invoke-GitlabApi @GitlabApiArguments -WhatIf:$WhatIf | Out-Null

        Write-Host "Environment '$($Environment.Name)' (id: $($Environment.Id)) has been stopped"
    }
}

function Remove-GitlabEnvironment {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $Name,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    process {
        $Project = Get-GitlabProject -ProjectId $ProjectId
        $Environment = Get-GitlabEnvironment -ProjectId $Project.Id -Name $Name
    
        $GitlabApiArguments = @{
            HttpMethod='DELETE'
            Path="projects/$($Project.Id)/environments/$($Environment.Id)"
            SiteUrl = $SiteUrl
        }
    
        Invoke-GitlabApi @GitlabApiArguments -WhatIf:$WhatIf | Out-Null
    
        Write-Host "Environment '$($Environment.Name)' (id: $($Environment.Id)) has been deleted"
    }
}