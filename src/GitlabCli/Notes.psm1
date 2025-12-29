# https://docs.gitlab.com/ee/api/notes.html

function Get-GitlabIssueNote {
    [CmdletBinding()]
    [OutputType('Gitlab.Note')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $IssueId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    # https://docs.gitlab.com/ee/api/notes.html#list-project-issue-notes
    Invoke-GitlabApi GET "projects/$ProjectId/issues/$IssueId/notes" | New-GitlabObject 'Gitlab.Note'
}

function New-GitlabIssueNote {
    [Alias('Add-GitlabIssueNote')]
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Note')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $IssueId,

        [Parameter(Position=0, Mandatory)]
        [string]
        $Note,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    if ($PSCmdlet.ShouldProcess("issue #$IssueId", "Create new issue note ($Note)")) {
        # https://docs.gitlab.com/ee/api/notes.html#create-new-issue-note
        Invoke-GitlabApi POST "projects/$ProjectId/issues/$IssueId/notes" -Body @{body = $Note} | New-GitlabObject 'Gitlab.Note'
    }
}

function Get-GitlabMergeRequestNote {
    [CmdletBinding()]
    [OutputType('Gitlab.Note')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $MergeRequestId,

        [Parameter(Position=1)]
        [string]
        $NoteId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    # https://docs.gitlab.com/ee/api/notes.html#list-all-merge-request-notes
    $Url = "projects/$ProjectId/merge_requests/$MergeRequestId/notes"
    if ($NoteId) {
        # https://docs.gitlab.com/api/notes/#get-single-issue-note
        $Url += "/$NoteId"
    }

    Invoke-GitlabApi GET $Url | New-GitlabObject 'Gitlab.Note'
}
