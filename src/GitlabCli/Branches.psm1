function Get-GitlabBranch {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false,Position=0)]
        [string]
        $ProjectId = ".",

        [Parameter(Mandatory=$false)]
        [string]
        $Search,

        [Parameter(Mandatory=$false)]
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

    if($Branch) {
        $GitlabApiArguments["Path"] =+ "/$($Branch)"
    }

    if($Search) {
        $GitlabApiArguments["Query"]["search"] = $Search
    }

    Invoke-GitlabApi @GitlabApiArguments | ForEach-Object { $_ |
        New-WrapperObject -DisplayType 'Gitlab.Branch'}

}