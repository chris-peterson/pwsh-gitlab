function Get-GitlabEnvironment {
    [Alias('envs')]
    [CmdletBinding(DefaultParameterSetName='List')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Alias('Id')]
        [Alias('EnvironmentId')]
        [Parameter(ParameterSetName='Name')]
        [string]
        $Name,

        [Parameter(ParameterSetName='Search', Mandatory)]
        [string]
        $Search,

        [Parameter()]
        [ValidateSet('available', 'stopping', 'stopped')]
        [string]
        $State = 'available',

        [Parameter()]
        [switch]
        $Enrich,

        [Parameter()]
        [int]
        $MaxPages = 1,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    # https://docs.gitlab.com/ee/api/environments.html#list-environments
    $GitlabApiArguments = @{
        HttpMethod = 'GET'
        Path       = "projects/$($Project.Id)/environments"
        Query      = @{}
        MaxPages   = $MaxPages
    }

    $Numeric = 0
    if ([int]::TryParse($Name, [ref] $Numeric)) {
        # https://docs.gitlab.com/ee/api/environments.html#get-a-specific-environment
        $GitlabApiArguments.Path += "/$Numeric"
    } else {
        switch ($PSCmdlet.ParameterSetName) {
            Search {
                $GitlabApiArguments.Query.search = $Search
            }
        }

        if ($Name) {
            $GitlabApiArguments.Query.name = $Name
        }

        if ($State) {
            $GitlabApiArguments.Query.states = $State
        }
    }

    $Result = Invoke-GitlabApi @GitlabApiArguments
    if ($Enrich) {
        # More properties are returned from the single environment API than the batch one (e.g. most recent deployment)
        $Result | ForEach-Object {
            Get-GitlabEnvironment -ProjectId $ProjectId -EnvironmentId $_.id
        }
    } else {
        $Result | New-WrapperObject 'Gitlab.Environment'
    }
}

function Stop-GitlabEnvironment {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $Name,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    process {
        $Project = Get-GitlabProject -ProjectId $ProjectId
        $Environment = Get-GitlabEnvironment -ProjectId $Project.Id -Name $Name
    
        $GitlabApiArguments = @{
            HttpMethod='POST'
            Path="projects/$($Project.Id)/environments/$($Environment.Id)/stop"
        }
    
        if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)/$($Environment.Name)", "stop environment")) {
            Invoke-GitlabApi @GitlabApiArguments | Out-Null
            Write-Host "Environment '$($Environment.Name)' (id: $($Environment.Id)) has been stopped"
        }
    }
}

function Remove-GitlabEnvironment {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $Name,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl
    )

    process {
        $Project = Get-GitlabProject -ProjectId $ProjectId
        $Environment = Get-GitlabEnvironment -ProjectId $Project.Id -Name $Name
    
        $GitlabApiArguments = @{
            HttpMethod='DELETE'
            Path="projects/$($Project.Id)/environments/$($Environment.Id)"
        }
    
        if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)/$($Environment.Name)", "delete environment")) {
            Invoke-GitlabApi @GitlabApiArguments | Out-Null
            Write-Host "Environment '$($Environment.Name)' (id: $($Environment.Id)) has been deleted"
        }
    }
}