# Changelog

All notable changes to GitlabCli are recorded here, newest first.

## [Unreleased]

### Changes
- Added `New-GitlabMergeRequestNote` (alias `Add-GitlabMergeRequestNote`) to add comments to merge requests, matching the existing `New-GitlabIssueNote` cmdlet.
- Added `Update-GitlabIssueNote`, `Remove-GitlabIssueNote`, `Update-GitlabMergeRequestNote`, and `Remove-GitlabMergeRequestNote`, rounding out full CRUD support for issue and merge request comments. `Get-GitlabIssueNote` also gains a `-NoteId` parameter to retrieve a single note, matching `Get-GitlabMergeRequestNote`.

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
