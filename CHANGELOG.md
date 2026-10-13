# Changelog

All notable changes to GitlabCli are recorded here, newest first.

## [Unreleased]

### Changes
- Added `Get-GitlabPipelineTrigger`, `New-GitlabPipelineTrigger`, and `Remove-GitlabPipelineTrigger` to manage a project's pipeline trigger tokens. `Get-GitlabPipelineTrigger -Description` returns the triggers with that description, newest first, and `Remove-GitlabPipelineTrigger` takes triggers from the pipeline.
- Added `New-GitlabServiceAccountPersonalAccessToken` and `Remove-GitlabServiceAccountPersonalAccessToken` (alias `Revoke-GitlabServiceAccountPersonalAccessToken`) to create and revoke a group service account's personal access tokens.
- Added `Use-GitlabToken`, which runs a script block as another identity and stops using its token afterwards, including when the block throws. `-User` impersonates a user, `-ServiceAccount` runs as a group service account through a personal access token created for the block, and both revoke their token afterwards; `-Token` runs with a token you pass. Run as a service account, what the block creates (such as a pipeline trigger token) belongs to that account. Under `-WhatIf`, `-User` and `-ServiceAccount` report the token's creation and revocation and run the block as you, with `-WhatIf` in effect. `Start-GitlabUserImpersonation` and `Stop-GitlabUserImpersonation` remain for longer sessions.
- Added `Set-GitlabServiceAccount`, which returns the group service account with a username or creates it, and `Get-GitlabServiceAccount -Username`. Service accounts from `Get-GitlabServiceAccount -GroupId` carry `GroupId`, so they pipe into the token cmdlets, `Use-GitlabToken`, and `Set-GitlabProjectMember`.
- `New-GitlabServiceAccount` and `Set-GitlabServiceAccount` reject a `-Username` starting with `duo-`, `duo_`, `ai-`, or `ai_`, which GitLab reserves for its AI entities, before sending a request, so `-WhatIf` catches it too.
- `Set-GitlabProjectMember` and `Set-GitlabGroupMember` return a member who already has the requested access level without a request, and take a user or service account from the pipeline.
- `Set-GitlabProjectVariable` takes projects from the pipeline and sets the variable on each.
- `Get-GitlabProjectVariable -Key` and `Get-GitlabGroupVariable -Key` write a non-terminating not-found error for a missing key, which `-ErrorAction SilentlyContinue` suppresses. Other failures still throw.
- `-WhatIf`, `-Confirm`, and `-Verbose` output no longer includes the access token or the values of secret fields such as `token` and `value`. The fields are the keys of `$global:GitlabLogSecretValues`; set one to `$true` (for example `$global:GitlabLogSecretValues.token = $true`) to show its values while debugging.

### Bug Fixes
- `Set-GitlabProjectMember` and `Set-GitlabGroupMember` no longer require `-SiteUrl`, and `Set-GitlabProjectMember` finds an existing member instead of always trying to add one. A lookup failure other than not-found is raised instead of being treated as "not a member".
- `Set-GitlabProjectVariable` and `Set-GitlabGroupVariable` raise a failed existence check instead of trying to create the variable.
- `Update-GitlabPipelineSchedule -NewOwner` stops impersonating the new owner when taking ownership fails, instead of leaving the impersonation session active.
- `Stop-GitlabUserImpersonation -Verbose` names the user whose session stopped.
- Under `-WhatIf`, the local project and group ID cache is still written, instead of printing "What if" lines for it.

## [1.174.0] - 2026-09-28

### Changes
- Added `New-GitlabMergeRequestNote` (alias `Add-GitlabMergeRequestNote`) to add comments to merge requests, matching the existing `New-GitlabIssueNote` cmdlet.
- Added `Update-GitlabIssueNote`, `Remove-GitlabIssueNote`, `Update-GitlabMergeRequestNote`, and `Remove-GitlabMergeRequestNote`, rounding out full CRUD support for issue and merge request comments. `Get-GitlabIssueNote` also gains a `-NoteId` parameter to retrieve a single note, matching `Get-GitlabMergeRequestNote`.
- `Update-GitlabProject` gains a `-WikiAccessLevel` parameter (`disabled`, `private`, or `enabled`) to turn a project's wiki on or off.

## [1.173.0] - 2026-09-14

### Changes
- Listings come back sorted by default. Issues and merge requests sort by their GitLab reference (`group/project#7`, `group/project!7`); anything else carrying a last-updated timestamp comes back most recent first. Passing `-Sort` or `-OrderBy` leaves the server's ordering alone.
- `Get-GitlabMergeRequest` groups by project and merge request iid rather than by project path alone.
- `Get-GitlabIssueNote` returns the newest comment first.
- `Get-GitlabBranch` reports a branch's tip-commit date as `UpdatedAt` rather than `LastUpdated`, matching every other type. Scripts reading `LastUpdated` need updating.

## [1.172.3] - 2026-09-12

### Bug Fixes
- Paged requests keep their authentication past the first page. On PowerShell 7.6, anything using `-All` over more than one page of results could come back truncated or fail with a 401: https://github.com/chris-peterson/pwsh-gitlab/pull/167
- Setting `$env:GITLAB_URL` without `$env:GITLAB_ACCESS_TOKEN` now names the missing token instead of failing with an unexplained "Could not resolve GitLab site": https://github.com/chris-peterson/pwsh-gitlab/pull/159

## [1.172.2] - 2026-06-29

### Bug Fixes
- https://github.com/chris-peterson/pwsh-gitlab/pull/158 - Thanks @rnebular
