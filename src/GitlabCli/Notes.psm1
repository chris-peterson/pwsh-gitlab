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

        [Parameter(Position=1)]
        [string]
        $NoteId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    # https://docs.gitlab.com/ee/api/notes.html#list-project-issue-notes
    $Url = "projects/$ProjectId/issues/$IssueId/notes"
    if ($NoteId) {
        # https://docs.gitlab.com/ee/api/notes.html#retrieve-an-issue-note
        $Url += "/$NoteId"
    }

    Invoke-GitlabApi GET $Url | New-GitlabObject 'Gitlab.Note'
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

function Update-GitlabIssueNote {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Note')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $IssueId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $NoteId,

        [Parameter(Position=0, Mandatory)]
        [string]
        $Note,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    if ($PSCmdlet.ShouldProcess("issue #$IssueId note $NoteId", "Update issue note ($Note)")) {
        # https://docs.gitlab.com/ee/api/notes.html#update-an-issue-note
        Invoke-GitlabApi PUT "projects/$ProjectId/issues/$IssueId/notes/$NoteId" -Body @{body = $Note} | New-GitlabObject 'Gitlab.Note'
    }
}

function Remove-GitlabIssueNote {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([void])]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $IssueId,

        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $NoteId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    if ($PSCmdlet.ShouldProcess("issue #$IssueId note $NoteId", "Delete issue note")) {
        # https://docs.gitlab.com/ee/api/notes.html#delete-an-issue-note
        Invoke-GitlabApi DELETE "projects/$ProjectId/issues/$IssueId/notes/$NoteId" | Out-Null
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
        # https://docs.gitlab.com/ee/api/notes.html#retrieve-a-merge-request-note
        $Url += "/$NoteId"
    }

    Invoke-GitlabApi GET $Url | New-GitlabObject 'Gitlab.Note'
}

function New-GitlabMergeRequestNote {
    [Alias('Add-GitlabMergeRequestNote')]
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Note')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $MergeRequestId,

        [Parameter(Position=0, Mandatory)]
        [string]
        $Note,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    if ($PSCmdlet.ShouldProcess("MR #$MergeRequestId", "Create new merge request note ($Note)")) {
        # https://docs.gitlab.com/ee/api/notes.html#create-a-merge-request-note
        Invoke-GitlabApi POST "projects/$ProjectId/merge_requests/$MergeRequestId/notes" -Body @{body = $Note} | New-GitlabObject 'Gitlab.Note'
    }
}

function Update-GitlabMergeRequestNote {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.Note')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $MergeRequestId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $NoteId,

        [Parameter(Position=0, Mandatory)]
        [string]
        $Note,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    if ($PSCmdlet.ShouldProcess("MR #$MergeRequestId note $NoteId", "Update merge request note ($Note)")) {
        # https://docs.gitlab.com/ee/api/notes.html#update-a-merge-request-note
        Invoke-GitlabApi PUT "projects/$ProjectId/merge_requests/$MergeRequestId/notes/$NoteId" -Body @{body = $Note} | New-GitlabObject 'Gitlab.Note'
    }
}

function Remove-GitlabMergeRequestNote {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([void])]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $ProjectId = '.',

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]
        $MergeRequestId,

        [Parameter(Position=0, Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $NoteId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $ProjectId = Resolve-GitlabProjectId $ProjectId

    if ($PSCmdlet.ShouldProcess("MR #$MergeRequestId note $NoteId", "Delete merge request note")) {
        # https://docs.gitlab.com/ee/api/notes.html#delete-a-merge-request-note
        Invoke-GitlabApi DELETE "projects/$ProjectId/merge_requests/$MergeRequestId/notes/$NoteId" | Out-Null
    }
}
