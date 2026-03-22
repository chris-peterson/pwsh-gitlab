function Get-GitlabRelease {
    [CmdletBinding()]
    [OutputType('Gitlab.Release')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0)]
        [string]
        $Tag,

        [Parameter()]
        [ValidateSet([SortDirection])]
        [string]
        $Sort = 'desc',

        [Parameter()]
        [switch]
        $IncludeHtml,

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

    $Path = "projects/$ProjectId/releases"
    $Query = @{}
    if ($Tag) {
        $Path += "/$Tag"
    }
    if ($Sort) {
        $Query.sort = $Sort
    }
    if ($IncludeHtml) {
        $Query.include_html_description = 'true';
    }
    $MaxPages = Resolve-GitlabMaxPages -MaxPages:$MaxPages -All:$All

    # https://docs.gitlab.com/ee/api/releases/#list-releases
    Invoke-GitlabApi GET $Path -Query $Query -MaxPages $MaxPages | New-GitlabObject 'Gitlab.Release' | ForEach-Object {
        $_ | Add-Member -PassThru -NotePropertyMembers @{ ProjectId = $ProjectId }
    }
}

function New-GitlabRelease {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Release')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory, Position=0)]
        [Alias('Tag')]
        [string]
        $TagName,

        [Parameter()]
        [string]
        $Name,

        [Parameter()]
        [string]
        $Description,

        [Parameter()]
        [Alias('Branch')]
        [string]
        $Ref = '.',

        [Parameter()]
        [string[]]
        $Milestones,

        [Parameter()]
        [GitlabDate()][string]
        $ReleasedAt,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId
    $Ref = Resolve-GitlabBranch $Ref

    $Body = @{
        tag_name = $TagName
    }
    if ($Name) {
        $Body.name = $Name
    }
    if ($Description) {
        $Body.description = $Description
    }
    if ($Ref) {
        $Body.ref = $Ref
    }
    if ($Milestones) {
        $Body.milestones = $Milestones
    }
    if ($ReleasedAt) {
        $Body.released_at = $ReleasedAt
    }

    if ($PSCmdlet.ShouldProcess("project $ProjectId", "create release '$TagName'")) {
        # https://docs.gitlab.com/ee/api/releases/#create-a-release
        Invoke-GitlabApi POST "projects/$ProjectId/releases" -Body $Body |
            New-GitlabObject 'Gitlab.Release'
    }
}

function Update-GitlabRelease {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Release')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [Alias('Tag')]
        [string]
        $TagName,

        [Parameter()]
        [string]
        $Name,

        [Parameter()]
        [string]
        $Description,

        [Parameter()]
        [string[]]
        $Milestones,

        [Parameter()]
        [GitlabDate()][string]
        $ReleasedAt,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    $Body = @{}
    if ($PSBoundParameters.ContainsKey('Name')) {
        $Body.name = $Name
    }
    if ($PSBoundParameters.ContainsKey('Description')) {
        $Body.description = $Description
    }
    if ($Milestones) {
        $Body.milestones = $Milestones
    }
    if ($ReleasedAt) {
        $Body.released_at = $ReleasedAt
    }

    if ($Body.Count -eq 0) {
        Write-Warning 'No properties to update'
        return
    }

    if ($PSCmdlet.ShouldProcess("project $ProjectId", "update release '$TagName'")) {
        # https://docs.gitlab.com/ee/api/releases/#update-a-release
        Invoke-GitlabApi PUT "projects/$ProjectId/releases/$TagName" -Body $Body |
            New-GitlabObject 'Gitlab.Release'
    }
}

function Remove-GitlabRelease {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([void])]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Mandatory, Position=0, ValueFromPipelineByPropertyName)]
        [Alias('Tag')]
        [string]
        $TagName,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    if ($PSCmdlet.ShouldProcess("project $ProjectId", "delete release '$TagName'")) {
        # https://docs.gitlab.com/ee/api/releases/#delete-a-release
        Invoke-GitlabApi DELETE "projects/$ProjectId/releases/$TagName" | Out-Null
    }
}
