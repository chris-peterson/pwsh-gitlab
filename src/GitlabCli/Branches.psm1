function Get-GitlabBranch {
    [CmdletBinding(DefaultParameterSetName="ByProjectId")]
    param (
        [Parameter(ParameterSetName="ByProjectId",Mandatory=$false)]
        [Parameter(ParameterSetName="ByRef",Mandatory=$false)]
        [string]
        $ProjectId = ".",

        [Parameter(ParameterSetName="ByProjectId",Mandatory=$false)]
        [string]
        $Search,

        [Parameter(ParameterSetName="ByRef", Mandatory=$true)]
        [Alias("Ref")]
        [string]
        $Branch
    )

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $GitlabApiArguments = @{
        HttpMethod="GET"
        Path="projects/$($Project.Id)/repository/branches"
        Query=@{}
    }

    switch($PSCmdlet.ParameterSetName) {
        ByProjectId {
            if($Search) {
                $GitlabApiArguments["Query"]["search"] = $Search
            }        
        }
        ByRef {
            $GitlabApiArguments["Path"] =+ "/$($Branch)"
        }
        default {
            throw "Parameterset $($PSCmdlet.ParameterSetName) is not implemented"
        }
    }

    Invoke-GitlabApi @GitlabApiArguments | ForEach-Object { $_ |
        New-WrapperObject -DisplayType 'Gitlab.Branch'}

}