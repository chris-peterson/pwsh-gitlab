function Get-GitlabLabel {
    [CmdletBinding(DefaultParameterSetName='ByProjectId')]
    [OutputType('Gitlab.Label')]
    [Alias('labels')]
    param (
        [Parameter(ParameterSetName='ByProjectId', ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory, ParameterSetName='ByGroupId', ValueFromPipelineByPropertyName)]
        [string]
        $GroupId,

        [Parameter()]
        [string]
        $Name,

        [Parameter()]
        [string]
        $Search,

        [Parameter()]
        [switch]
        $IncludeAncestorGroups,

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

    $MaxPages = Resolve-GitlabMaxPages -MaxPages:$MaxPages -All:$All

    if ($GroupId) {
        $GroupId = Resolve-GitlabGroupId $GroupId
        $Path = "groups/$GroupId/labels"
    } else {
        $ProjectId = Resolve-GitlabProjectId $ProjectId
        $Path = "projects/$ProjectId/labels"
    }

    $Query = @{}
    if ($Search) {
        $Query.search = $Search
    }
    if ($IncludeAncestorGroups) {
        $Query.include_ancestor_groups = 'true'
    }

    # https://docs.gitlab.com/ee/api/labels.html#list-labels
    $Labels = Invoke-GitlabApi GET $Path -Query $Query -MaxPages $MaxPages |
        New-GitlabObject 'Gitlab.Label'

    if ($Name) {
        $Labels | Where-Object Name -eq $Name
    } else {
        $Labels
    }
}

function New-GitlabLabel {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Label')]
    param (
        [Parameter(ParameterSetName='ByProjectId', ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory, ParameterSetName='ByGroupId', ValueFromPipelineByPropertyName)]
        [string]
        $GroupId,

        [Parameter(Mandatory)]
        [string]
        $Name,

        [Parameter(Mandatory)]
        [string]
        $Color,

        [Parameter()]
        [string]
        $Description,

        [Parameter()]
        [int]
        $Priority,

        [Parameter()]
        [string]
        $SiteUrl
    )

    if ($GroupId) {
        $GroupId = Resolve-GitlabGroupId $GroupId
        $Path = "groups/$GroupId/labels"
        $Target = "group $GroupId"
    } else {
        $ProjectId = Resolve-GitlabProjectId $ProjectId
        $Path = "projects/$ProjectId/labels"
        $Target = "project $ProjectId"
    }

    $Body = @{
        name  = $Name
        color = $Color
    }
    if ($Description) {
        $Body.description = $Description
    }
    if ($PSBoundParameters.ContainsKey('Priority')) {
        $Body.priority = $Priority
    }

    if ($PSCmdlet.ShouldProcess($Target, "create label '$Name'")) {
        # https://docs.gitlab.com/ee/api/labels.html#create-a-new-label
        Invoke-GitlabApi POST $Path -Body $Body | New-GitlabObject 'Gitlab.Label'
    }
}

function Update-GitlabLabel {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Label')]
    param (
        [Parameter(ParameterSetName='ByProjectId', ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory, ParameterSetName='ByGroupId', ValueFromPipelineByPropertyName)]
        [string]
        $GroupId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [int]
        $LabelId,

        [Parameter()]
        [string]
        $NewName,

        [Parameter()]
        [string]
        $Color,

        [Parameter()]
        [string]
        $Description,

        [Parameter()]
        [nullable[int]]
        $Priority,

        [Parameter()]
        [string]
        $SiteUrl
    )

    if ($GroupId) {
        $GroupId = Resolve-GitlabGroupId $GroupId
        $Path = "groups/$GroupId/labels/$LabelId"
        $Target = "group $GroupId"
    } else {
        $ProjectId = Resolve-GitlabProjectId $ProjectId
        $Path = "projects/$ProjectId/labels/$LabelId"
        $Target = "project $ProjectId"
    }

    $Body = @{}
    if ($NewName) {
        $Body.new_name = $NewName
    }
    if ($Color) {
        $Body.color = $Color
    }
    if ($PSBoundParameters.ContainsKey('Description')) {
        $Body.description = $Description
    }
    if ($Priority.HasValue) {
        $Body.priority = $Priority.Value
    }

    if ($Body.Count -eq 0) {
        Write-Warning 'No properties to update'
        return
    }

    if ($PSCmdlet.ShouldProcess($Target, "update label $LabelId")) {
        # https://docs.gitlab.com/ee/api/labels.html#edit-an-existing-label
        Invoke-GitlabApi PUT $Path -Body $Body | New-GitlabObject 'Gitlab.Label'
    }
}

function Remove-GitlabLabel {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([void])]
    param (
        [Parameter(ParameterSetName='ByProjectId', ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory, ParameterSetName='ByGroupId', ValueFromPipelineByPropertyName)]
        [string]
        $GroupId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [int]
        $LabelId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    if ($GroupId) {
        $GroupId = Resolve-GitlabGroupId $GroupId
        $Path = "groups/$GroupId/labels/$LabelId"
        $Target = "group $GroupId"
    } else {
        $ProjectId = Resolve-GitlabProjectId $ProjectId
        $Path = "projects/$ProjectId/labels/$LabelId"
        $Target = "project $ProjectId"
    }

    if ($PSCmdlet.ShouldProcess($Target, "delete label $LabelId")) {
        # https://docs.gitlab.com/ee/api/labels.html#delete-a-label
        Invoke-GitlabApi DELETE $Path | Out-Null
    }
}
