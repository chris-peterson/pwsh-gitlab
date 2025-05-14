# https://docs.gitlab.com/ee/api/notes.html

function Get-GitlabIssueNote {
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

    $Project = Get-GitlabProject $ProjectId

    # https://docs.gitlab.com/ee/api/notes.html#list-project-issue-notes
    Invoke-GitlabApi GET "projects/$($Project.Id)/issues/$IssueId/notes" -SiteUrl $SiteUrl | New-WrapperObject 'Gitlab.Note'
}

function New-GitlabIssueNote {
    [Alias('Add-GitlabIssueNote')]
    [CmdletBinding(SupportsShouldProcess)]
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

    $Project = Get-GitlabProject $ProjectId

    if ($PSCmdlet.ShouldProcess("issue #$IssueId", "Create new issue note ($Note)")) {
        # https://docs.gitlab.com/ee/api/notes.html#create-new-issue-note
        Invoke-GitlabApi POST "projects/$($Project.Id)/issues/$IssueId/notes" -Body @{body = $Note} -SiteUrl $SiteUrl | New-WrapperObject 'Gitlab.Note'
    }
}

function Get-GitlabMergeRequestNote {
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

    $Project = Get-GitlabProject $ProjectId

    # https://docs.gitlab.com/ee/api/notes.html#list-all-merge-request-notes
    $Url = "projects/$($Project.Id)/merge_requests/$MergeRequestId/notes"
    if ($NoteId) {
        # https://docs.gitlab.com/api/notes/#get-single-issue-note
        $Url += "/$NoteId"
    }

    Invoke-GitlabApi GET $Url -SiteUrl $SiteUrl | New-WrapperObject 'Gitlab.Note'
}
