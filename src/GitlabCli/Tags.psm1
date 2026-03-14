function Get-GitlabTag {
    [CmdletBinding()]
    [OutputType('Gitlab.Tag')]
    [Alias('tags')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0)]
        [string]
        $Name,

        [Parameter()]
        [string]
        $Search,

        [Parameter()]
        [ValidateSet([SortDirection])]
        [string]
        $Sort,

        [Parameter()]
        [ValidateSet('name', 'updated', 'version')]
        [string]
        $OrderBy,

        [Parameter()]
        [uint]
        $MaxPages,

        [switch]
        [Parameter()]
        $All,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    $Path = "projects/$ProjectId/repository/tags"
    $Query = @{}

    if ($Name) {
        $Path += "/$Name"
    } else {
        if ($Search) {
            $Query.search = $Search
        }
        if ($Sort) {
            $Query.sort = $Sort
        }
        if ($OrderBy) {
            $Query.order_by = $OrderBy
        }
    }

    $MaxPages = Resolve-GitlabMaxPages -MaxPages:$MaxPages -All:$All

    # https://docs.gitlab.com/ee/api/tags.html#list-project-repository-tags
    Invoke-GitlabApi GET $Path -Query $Query -MaxPages $MaxPages |
        New-GitlabObject 'Gitlab.Tag'
}

function New-GitlabTag {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Tag')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory, Position=0)]
        [string]
        $Name,

        [Parameter(Mandatory)]
        [Alias('Branch')]
        [string]
        $Ref,

        [Parameter()]
        [string]
        $Message,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    $Body = @{
        tag_name = $Name
        ref      = $Ref
    }
    if ($Message) {
        $Body.message = $Message
    }

    if ($PSCmdlet.ShouldProcess("project $ProjectId", "create tag '$Name' from '$Ref'")) {
        # https://docs.gitlab.com/ee/api/tags.html#create-a-new-tag
        Invoke-GitlabApi POST "projects/$ProjectId/repository/tags" -Body $Body |
            New-GitlabObject 'Gitlab.Tag'
    }
}

function Remove-GitlabTag {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([void])]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [string]
        $Name,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    if ($PSCmdlet.ShouldProcess("project $ProjectId", "delete tag '$Name'")) {
        # https://docs.gitlab.com/ee/api/tags.html#delete-a-tag
        Invoke-GitlabApi DELETE "projects/$ProjectId/repository/tags/$Name" | Out-Null
    }
}
