function Get-GitlabRelease {
    [CmdletBinding()]
    [OutputType('Gitlab.Release')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter()]
        [string]
        $Tag,

        [Parameter()]
        [ValidateSet('desc', 'asc')]
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
    Invoke-GitlabApi GET $Path -Query $Query -MaxPages $MaxPages | New-GitlabObject 'Gitlab.Release' | ForEach-Object {
        $_ | Add-Member -PassThru -NotePropertyMembers @{ ProjectId = $Project.Id }
    }
}
