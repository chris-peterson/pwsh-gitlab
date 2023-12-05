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
        $MaxPages = $global:GitlabGetProjectDefaultPages,

        [switch]
        [Parameter()]
        $All
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
    if ($All) {
        $MaxPages = [uint]::MaxValue
    }

    Invoke-GitlabApi GET $Path -Query $Query -MaxPages $MaxPages | New-WrapperObject 'Gitlab.Release'
}
