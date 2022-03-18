# https://docs.gitlab.com/ee/api/notes.html

# https://docs.gitlab.com/ee/api/notes.html#list-project-issue-notes
function Get-GitlabIssueNote {
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $IssueId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject $ProjectId

    Invoke-GitlabApi GET "projects/$($Project.Id)/issues/$IssueId/notes" -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Note'
}

# https://docs.gitlab.com/ee/api/notes.html#create-new-issue-note
function New-GitlabIssueNote {
    param (
        [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $IssueId,

        [Parameter(Position=1, Mandatory=$true)]
        [string]
        $Note,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject $ProjectId

    Invoke-GitlabApi POST "projects/$($Project.Id)/issues/$IssueId/notes" -Body @{body = $Note} -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Note'
}

# https://docs.gitlab.com/ee/api/notes.html#list-all-merge-request-notes
function Get-GitlabMergeRequestNote {
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [string]
        $ProjectId = '.',

        [Parameter(Position=0, Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        $MergeRequestId,

        [Parameter(Position=1, Mandatory=$false)]
        [string]
        $NoteId,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $Project = Get-GitlabProject $ProjectId

    $Url = "projects/$($Project.Id)/merge_requests/$MergeRequestId/notes"
    if ($NoteId) {
        $Url += "/$NoteId"
    }

    Invoke-GitlabApi GET $Url -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.Note'
}
