# Merge request helper functions

function Add-GitlabMergeRequestApprovals {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '', Justification = 'Adds multiple approval properties to MR object')]
    param(
        [Parameter(Position=0, Mandatory, ValueFromPipeline)]
        $MergeRequest
    )

    $Approval = Invoke-GitlabApi GET "projects/$($MergeRequest.SourceProjectId)/merge_requests/$($MergeRequest.MergeRequestId)/approvals"

    $MergeRequest | Add-Member -NotePropertyMembers @{
        ApprovalsRequired = $Approval.approvals_required
        ApprovalsLeft     = $Approval.approvals_left
        ApprovedBy        = $Approval.approved_by.user.name
    }
}

function Add-GitlabMergeRequestChangeSummary {
    param (
        [Parameter(Position=0, Mandatory, ValueFromPipeline)]
        $MergeRequest,

        [Parameter()]
        [switch]
        $IncludeDiffs
    )

    # First query: get commit info without diffs (diffs have a 10 commit limit per request)
    $Data = Invoke-GitlabGraphQL -Query @"
    {
        project(fullPath: "$($MergeRequest.ProjectPath)") {
            mergeRequest(iid: "$($MergeRequest.MergeRequestId)") {
                diffStatsSummary {
                    additions
                    deletions
                    files: fileCount
                }
                commitsWithoutMergeCommits {
                    nodes {
                      author {
                          username
                      }
                      authoredDate
                    }
                }
                notes {
                    nodes {
                      id
                      author {
                          username
                      }
                      body
                      updatedAt
                    }
                }
            }
        }
    }
"@

    $Mr = $Data.Project.mergeRequest
    $Notes = $Mr.notes.nodes | Sort-Object -Descending updatedAt

    $SpecialNotes = @{
        SelfAssigned         = @{ Regex="^assigned to @$($MergeRequest.Author.username)"; Notes=@() }
        Assigned             = @{ Regex='^assigned to @'; Notes=@() }
        DescriptionChanges   = @{ Regex='^changed the description'; Notes=@() }
        TitleChanges         = @{ Regex='^<div>changed title from'; Notes=@() }
        MarkedDraft          = @{ Regex='^marked this merge request as \*\*draft\*\*'; Notes=@() }
        MarkedReady          = @{ Regex='^marked this merge request as \*\*ready\*\*'; Notes=@() }
        ReviewRequested      = @{ Regex='^requested review from @'; Notes=@() }
        Approved             = @{ Regex='^approved this merge request'; Notes=@() }
        Commits              = @{ Regex='^added \d+ commit'; Notes=@() }
        MentionCommits       = @{ Regex="^mentioned in commit"; Notes=@() }
        MentionMergeRequests = @{ Regex="^mentioned in merge request"; Notes=@() }
        Edits                = @{ Regex="^changed this line in \[version"; Notes=@() }
        PostMergeCommits     = @{ Regex="^deleted the `.*` branch."; Notes=@() }
    }
    $SpecialNoteIds = @()
    foreach ($Key in $SpecialNotes.Keys) {
        $Special = $Notes | Where-Object body -Match $SpecialNotes[$Key].Regex
        if ($Special) {
            $SpecialNotes[$Key].Notes = $Special
            $SpecialNoteIds += $Special.id
        }
    }
    $RegularComments = $Notes | Where-Object {
        $SpecialNoteIds -notcontains $_.id
    }
    $SelfComments     = $RegularComments | Where-Object { $_.author.username -eq $MergeRequest.Author.username }
    $ReviewerComments = $RegularComments | Where-Object { $_.author.username -ne $MergeRequest.Author.username }

    $Summary = [PSCustomObject]@{
        Changes                 = $Mr.diffStatsSummary | New-GitlabObject
        Authors                 = $Mr.commitsWithoutMergeCommits.nodes.author.username | Select-Object -Unique | Sort-Object
        FirstCommittedAt        = @($Mr.commitsWithoutMergeCommits.nodes.authoredDate) + @($SpecialNotes.Commits.Notes.updatedAt) | Sort-Object | Select-Object -First 1
        ReviewRequestedAt       = $SpecialNotes.ReviewRequested.Notes | Select-Object -First 1 | Select-Object -ExpandProperty updatedAt
        AssignedAt              = $SpecialNotes.SelfAssigned.Notes | Select-Object -First 1 | Select-Object -ExpandProperty updatedAt
        MarkedReadyAt           = $SpecialNotes.MarkedReady.Notes | Select-Object -First 1 | Select-Object -ExpandProperty updatedAt
        ApprovedAt              = $SpecialNotes.Approved.Notes | Select-Object -First 1 | Select-Object -ExpandProperty updatedAt
        FirstNonAuthorCommentAt = $ReviewerComments | Select-Object -First 1 | Select-Object -ExpandProperty updatedAt
        TimeToMerge             = '(computed below)'
    }
    if ($DebugPreference -eq 'Continue') {
        $Summary | Add-Member -NotePropertyMembers @{
            Commits         = $Mr.commitsWithoutMergeCommits.nodes
            SpecialNotes     = $SpecialNotes
            ReviewerComments = $ReviewerComments
            SelfComments     = $SelfComments
        }
    }

    $MergedAt = $MergeRequest.MergedAt
    if ($Summary.ReviewRequestedAt) {
        $Summary.TimeToMerge = @{ Duration = $MergedAt - $Summary.ReviewRequestedAt; Measure='FromReviewRequested' }
    } elseif ($Summary.AssignedAt) {
        $Summary.TimeToMerge = @{ Duration = $MergedAt - $Summary.AssignedAt; Measure='FromAssigned' }
    } else {
        $Summary.TimeToMerge = @{ Duration = $MergedAt - $MergeRequest.CreatedAt; Measure='FromCreated'}
    }

    $MergeRequest | Add-Member -NotePropertyMembers @{
        ChangeSummary = $Summary
    }

    if ($IncludeDiffs) {
        # GitLab limits diffs to 10 commits per request, so use cursor-based pagination
        $BatchSize = 10
        $AllDiffs = @()
        $HasNextPage = $true
        $AfterCursor = $null

        while ($HasNextPage) {
            $AfterArg = if ($AfterCursor) { ", after: `"$AfterCursor`"" } else { '' }

            $DiffData = Invoke-GitlabGraphQL -Query @"
            {
                project(fullPath: "$($MergeRequest.ProjectPath)") {
                    mergeRequest(iid: "$($MergeRequest.MergeRequestId)") {
                        commitsWithoutMergeCommits(first: $BatchSize$AfterArg) {
                            pageInfo {
                                hasNextPage
                                endCursor
                            }
                            nodes {
                                diffs { newFile newPath oldPath diff }
                            }
                        }
                    }
                }
            }
"@
            $CommitsResult = $DiffData.Project.mergeRequest.commitsWithoutMergeCommits
            $HasNextPage = $CommitsResult.pageInfo.hasNextPage
            $AfterCursor = $CommitsResult.pageInfo.endCursor

            $BatchDiffs = @($CommitsResult.nodes | ForEach-Object {
                $_.diffs | ForEach-Object {
                    [PSCustomObject]@{
                        Path = if ($_.newFile -eq 'true') { $_.newPath } else { $_.oldPath }
                        Diff = $_.diff
                    }
                }
            })
            $AllDiffs += $BatchDiffs
        }

        Write-Verbose "!$($MergeRequest.MergeRequestId) has $($AllDiffs.Count) diffs"
        $MergeRequest | Add-Member -NotePropertyName Diffs -NotePropertyValue $AllDiffs
    }
}
