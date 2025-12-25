function Get-GitlabRelease {
    [CmdletBinding()]
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

    $Project = Get-GitlabProject $ProjectId

    $Path = "projects/$($Project.Id)/releases"
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
    Invoke-GitlabApi GET $Path -Query $Query -MaxPages $MaxPages | New-WrapperObject 'Gitlab.Release' | ForEach-Object {
        $_ | Add-Member -PassThru -NotePropertyMembers @{ ProjectId = $Project.Id }
    }
}
