@{
    ModuleVersion = '1.175.0'

    RequiredModules = @(
        @{
            ModuleName = 'powershell-yaml'
            RequiredVersion = '0.4.12'
        }
    )

    PrivateData = @{
        PSData = @{
            LicenseUri = 'https://github.com/chris-peterson/pwsh-gitlab/blob/main/LICENSE'
            ProjectUri = 'https://chris-peterson.github.io/pwsh-gitlab/'
            IconUri = 'https://chris-peterson.github.io/pwsh-gitlab/icon.png'
            Tags = @(
                'GitLab',
                'API',
                'REST',
                'GraphQL',
                'CI/CD',
                'DevOps',
                'Automation',
                'PowerShell',
                'Module',
                'PSEdition_Desktop',
                'PSEdition_Core',
                'Windows',
                'Linux',
                'MacOS'
            )
            ReleaseNotes =
@'
### Changes
- Added `Get-GitlabPipelineTrigger`, `New-GitlabPipelineTrigger`, and `Remove-GitlabPipelineTrigger` to manage a project's pipeline trigger tokens. `Get-GitlabPipelineTrigger -Description` returns the triggers with that description, newest first, and `Remove-GitlabPipelineTrigger` takes triggers from the pipeline.
- Added `New-GitlabServiceAccountPersonalAccessToken` and `Remove-GitlabServiceAccountPersonalAccessToken` (alias `Revoke-GitlabServiceAccountPersonalAccessToken`) to create and revoke a group service account's personal access tokens.
- Added `Use-GitlabToken`, which runs a script block as another identity and stops using its token afterwards, including when the block throws. `-User` impersonates a user, `-ServiceAccount` runs as a group service account through a personal access token created for the block, and both revoke their token afterwards; `-Token` runs with a token you pass. Run as a service account, what the block creates (such as a pipeline trigger token) belongs to that account. Under `-WhatIf`, `-User` and `-ServiceAccount` report the token's creation and revocation and run the block as you, with `-WhatIf` in effect. The temporary token stays valid for at least `$global:GitlabTemporaryTokenLifetime` (1 hour by default). `Start-GitlabUserImpersonation` and `Stop-GitlabUserImpersonation` remain for longer sessions.
- Added `Set-GitlabServiceAccount`, which returns the group service account with a username or creates it, and `Get-GitlabServiceAccount -Username`. Service accounts from `Get-GitlabServiceAccount -GroupId` carry `GroupId`, so they pipe into the token cmdlets, `Use-GitlabToken`, and `Set-GitlabProjectMember`.
- `New-GitlabServiceAccount` and `Set-GitlabServiceAccount` reject a `-Username` starting with `duo-`, `duo_`, `ai-`, or `ai_`, which GitLab reserves for its AI entities, before sending a request, so `-WhatIf` catches it too.
- `Set-GitlabProjectMember` and `Set-GitlabGroupMember` return a member who already has the requested access level without a request, and take a user or service account from the pipeline.
- `Set-GitlabProjectVariable` takes projects from the pipeline and sets the variable on each.
- Added `Set-GitlabProjectAvatar`, `Set-GitlabGroupAvatar`, and `Set-GitlabTopicAvatar` to set an avatar image from a file or a `data:` URI, and `Remove-GitlabProjectAvatar`, `Remove-GitlabGroupAvatar`, and `Remove-GitlabTopicAvatar` to clear it. GitLab doesn't accept SVG avatars, so an SVG is converted to a PNG first; this needs `rsvg-convert`, ImageMagick, or (on macOS) the built-in `sips`.
- `Invoke-GitlabApi -Form` sends multipart form data, including file uploads.
- `Get-GitlabProjectVariable -Key` and `Get-GitlabGroupVariable -Key` write a non-terminating not-found error for a missing key, which `-ErrorAction SilentlyContinue` suppresses. Other failures still throw.

### Bug Fixes
- [Secrets no longer print to the console](https://github.com/chris-peterson/pwsh-gitlab/issues/178). `-WhatIf` and `-Verbose` show the access token and other credential fields as `********`. Project, group, pipeline, and pipeline schedule variables show `********` in place of the value when the variable is masked or hidden, or when its key looks like a secret (contains `TOKEN`, `SECRET`, `PASSWORD`, `PASSWD`, `KEY`, `CREDENTIAL`, or `PRIVATE`). Only the display changes: `.Value` still returns the real value. `Set-GitlabProjectVariable` and `Set-GitlabGroupVariable` also keep an existing variable masked when it's updated without `-Mask`.
- `Set-GitlabProjectMember` and `Set-GitlabGroupMember` no longer require `-SiteUrl`, and `Set-GitlabProjectMember` finds an existing member instead of always trying to add one. A lookup failure other than not-found is raised instead of being treated as "not a member".
- `Set-GitlabProjectVariable` and `Set-GitlabGroupVariable` raise a failed existence check instead of trying to create the variable.
- `Update-GitlabPipelineSchedule -NewOwner` stops impersonating the new owner when taking ownership fails, instead of leaving the impersonation session active.
- `Start-GitlabUserImpersonation` no longer creates an impersonation token that's already expired. Its expiry was the next day's local date, but GitLab expires a token at 00:00 UTC on that date, so late in the day west of UTC the token was expired on creation. It now stays valid for at least `$global:GitlabTemporaryTokenLifetime` (1 hour by default).
- `Stop-GitlabUserImpersonation -Verbose` names the user whose session stopped.
- Under `-WhatIf`, the local project and group ID cache is still written, instead of printing "What if" lines for it.
'@
        }
    }

    GUID = '220fdbee-bea7-4951-9375-f6e76bd981b4'

    Author = 'Chris Peterson'
    CompanyName = 'Chris Peterson'
    Copyright = '(c) 2021-2026'

    Description = 'Interact with GitLab via PowerShell'
    PowerShellVersion = '7.1'
    CompatiblePSEditions = @('Core', 'Desktop')

    ScriptsToProcess = @(
        'Private/Functions/ApiHelpers.ps1'
        'Private/Functions/AvatarHelpers.ps1'
        'Private/Functions/BranchHelpers.ps1'
        'Private/Functions/CacheHelpers.ps1'
        'Private/Functions/StringHelpers.ps1'
        'Private/Functions/TokenHelpers.ps1'
        'Private/Functions/ConfigurationHelpers.ps1'
        'Private/Functions/GroupHelpers.ps1'
        'Private/Functions/JobHelpers.ps1'
        'Private/Functions/MergeRequestHelpers.ps1'
        'Private/Functions/ObjectHelpers.ps1'
        'Private/Functions/PaginationHelpers.ps1'
        'Private/Functions/SensitiveValueHelpers.ps1'
        'Private/Functions/RunnerHelpers.ps1'
        'Private/Validations.ps1'
        'Private/Globals.ps1'
        'Private/Transformations.ps1'
    )
    TypesToProcess = @('Types.ps1xml')
    FormatsToProcess = @('Formats.ps1xml')

    NestedModules = @(
        'AuditEvents.psm1'
        'Branches.psm1'
        'Commits.psm1'
        'Config.psm1'
        'DeployKeys.psm1'
        'Deployments.psm1'
        'Environments.psm1'
        'Git.psm1'
        'GraphQL.psm1'
        'GroupAccessTokens.psm1'
        'Groups.psm1'
        'Integrations.psm1'
        'Issues.psm1'
        'Jobs.psm1'
        'Keys.psm1'
        'Labels.psm1'
        'Members.psm1'
        'MergeRequests.psm1'
        'Milestones.psm1'
        'Notes.psm1'
        'PersonalAccessTokens.psm1'
        'Pipelines.psm1'
        'PipelineSchedules.psm1'
        'PipelineTriggers.psm1'
        'ProjectAccessTokens.psm1'
        'ProjectDeployKeys.psm1'
        'Projects.psm1'
        'ProjectHooks.psm1'
        'RepositoryFiles.psm1'
        'Releases.psm1'
        'Runners.psm1'
        'Search.psm1'
        'ServiceAccounts.psm1'
        'Snippets.psm1'
        'Tags.psm1'
        'Todos.psm1'
        'Topics.psm1'
        'UserDeployKeys.psm1'
        'Users.psm1'
        'Utilities.psm1'
        'Variables.psm1'
    )
    FunctionsToExport = @(
        # Git
        'Get-LocalGitContext'

        # AuditEvents
        'Get-GitlabAuditEvent'

        # Branches
        'Get-GitlabBranch'
        'Get-GitlabProtectedBranch'
        'New-GitlabBranch'
        'Protect-GitlabBranch'
        'UnProtect-GitlabBranch'
        'Remove-GitlabBranch'

        # Commits
        'Get-GitlabCommit'

        # Configuration
        'Get-GitlabConfiguration'
        'Add-GitlabSite'
        'Remove-GitlabSite'
        'Get-DefaultGitlabSite'
        'Set-DefaultGitlabSite'

        # Deploy Keys
        'Get-GitlabDeployKey'

        # GraphQL
        'Invoke-GitlabGraphQL'

        # Group Access Tokens
        'Get-GitlabGroupAccessToken'
        'New-GitlabGroupAccessToken'
        'Remove-GitlabGroupAccessToken'

        # Groups
        'Copy-GitlabGroupToLocalFileSystem'
        'Get-GitlabGroup'
        'Get-GitlabGroupVariable'
        'Move-GitlabGroup'
        'New-GitlabGroup'
        'New-GitlabGroupToGroupShare'
        'Remove-GitlabGroup'
        'Remove-GitlabGroupAvatar'
        'Remove-GitlabGroupToGroupShare'
        'Remove-GitlabGroupVariable'
        'Rename-GitlabGroup'
        'Set-GitlabGroupAvatar'
        'Set-GitlabGroupVariable'
        'Update-GitlabGroup'
        'Update-LocalGitlabGroup'

        # SSH Keys
        'Get-GitlabKey'

        # Labels
        'Get-GitlabLabel'
        'New-GitlabLabel'
        'Update-GitlabLabel'
        'Remove-GitlabLabel'

        # Project Access Tokens
        'Get-GitlabProjectAccessToken'
        'New-GitlabProjectAccessToken'
        'Remove-GitlabProjectAccessToken'
        'Invoke-GitlabProjectAccessTokenRotation'

        # Project Deploy Keys
        'Get-GitlabProjectDeployKey'
        'Add-GitlabProjectDeployKey'
        'Update-GitlabProjectDeployKey'
        'Remove-GitlabProjectDeployKey'
        'Enable-GitlabProjectDeployKey'

        # Projects
        'Add-GitlabProjectTopic'
        'ConvertTo-GitlabTriggerYaml'
        'Copy-GitlabProject'
        'Get-GitlabProject'
        'Get-GitlabProjectHook'
        'Get-GitlabProjectVariable'
        'Invoke-GitlabProjectArchival'
        'Invoke-GitlabProjectUnarchival'
        'Move-GitlabProject'
        'New-GitlabGroupToProjectShare'
        'New-GitlabProject'
        'New-GitlabProjectHook'
        'Remove-GitlabGroupToProjectShare'
        'Remove-GitlabProject'
        'Remove-GitlabProjectAvatar'
        'Remove-GitlabProjectForkRelationship'
        'Remove-GitlabProjectHook'
        'Remove-GitlabProjectTopic'
        'Remove-GitlabProjectVariable'
        'Rename-GitlabProject'
        'Rename-GitlabProjectDefaultBranch'
        'Set-GitlabProjectAvatar'
        'Set-GitlabProjectVariable'
        'Update-GitlabProject'
        'Update-GitlabProjectHook'

        # Repository Files
        'Get-GitlabRepositoryFile'
        'Get-GitlabRepositoryTree'
        'Get-GitlabRepositoryFileContent'
        'Get-GitlabRepositoryYmlFileContent'
        'New-GitlabRepositoryFile'
        'Update-GitlabRepositoryFile'

        # Environments
        'Get-GitlabEnvironment'
        'Stop-GitlabEnvironment'
        'Remove-GitlabEnvironment'

        # Deployments
        'Get-GitlabDeployment'

        # Issues
        'Get-GitlabIssue'
        'New-GitlabIssue'
        'Update-GitlabIssue'
        'Open-GitlabIssue'
        'Close-GitlabIssue'

        # Notes
        'Get-GitlabIssueNote'
        'New-GitlabIssueNote'
        'Update-GitlabIssueNote'
        'Remove-GitlabIssueNote'
        'Get-GitlabMergeRequestNote'
        'New-GitlabMergeRequestNote'
        'Update-GitlabMergeRequestNote'
        'Remove-GitlabMergeRequestNote'

        # MergeRequests
        'Get-GitlabMergeRequest'
        'New-GitlabMergeRequest'
        'Merge-GitlabMergeRequest'
        'Set-GitlabMergeRequest'
        'Invoke-GitlabMergeRequestReview'
        'Approve-GitlabMergeRequest'
        'Update-GitlabMergeRequest'
        'Close-GitlabMergeRequest'
        # MergeRequest Approvals
        'Get-GitlabMergeRequestApproval'
        'Get-GitlabMergeRequestApprovalConfiguration'
        'Update-GitlabMergeRequestApprovalConfiguration'
        'Get-GitlabMergeRequestApprovalRule'
        'New-GitlabMergeRequestApprovalRule'
        'Remove-GitlabMergeRequestApprovalRule'

        # Milestones
        'Get-GitlabMilestone'
        'New-GitlabMilestone'
        'Update-GitlabMilestone'
        'Remove-GitlabMilestone'

        # PATs
        'Get-GitlabPersonalAccessToken'
        'New-GitlabPersonalAccessToken'
        'Invoke-GitlabPersonalAccessTokenRotation'
        'Revoke-GitlabPersonalAccessToken'

        # Service Accounts
        'Get-GitlabServiceAccount'
        'New-GitlabServiceAccount'
        'New-GitlabServiceAccountPersonalAccessToken'
        'Remove-GitlabServiceAccount'
        'Remove-GitlabServiceAccountPersonalAccessToken'
        'Set-GitlabServiceAccount'
        'Update-GitlabServiceAccount'

        # Pipelines
        'Get-GitlabPipeline'
        'Get-GitlabPipelineVariable'
        'New-GitlabPipeline'
        'Remove-GitlabPipeline'
        'Stop-GitlabPipeline'
        'Get-GitlabPipelineScheduleVariable'
        'New-GitlabPipelineScheduleVariable'
        'Remove-GitlabPipelineScheduleVariable'
        'Update-GitlabPipelineScheduleVariable'
        'New-GitlabScheduledPipeline'
        'Get-GitlabPipelineBridge'

        # Pipeline Schedules
        'Get-GitlabPipelineSchedule'
        'New-GitlabPipelineSchedule'
        'Update-GitlabPipelineSchedule'
        'Enable-GitlabPipelineSchedule'
        'Disable-GitlabPipelineSchedule'
        'Remove-GitlabPipelineSchedule'

        # Pipeline Triggers
        'Get-GitlabPipelineTrigger'
        'New-GitlabPipelineTrigger'
        'Remove-GitlabPipelineTrigger'

        # Jobs
        'Get-GitlabJob'
        'Get-GitlabJobTrace'
        'Get-GitlabJobArtifact'
        'Start-GitlabJob'
        'Get-GitlabPipelineDefinition'
        'Test-GitlabPipelineDefinition'
        'Start-GitlabJobLogSection'
        'Stop-GitlabJobLogSection'
        'Write-GitlabJobTrace'

        # Releases
        'Get-GitlabRelease'
        'New-GitlabRelease'
        'Update-GitlabRelease'
        'Remove-GitlabRelease'

        # Tags
        'Get-GitlabTag'
        'New-GitlabTag'
        'Remove-GitlabTag'

        # Runners
        'Get-GitlabRunner'
        'Get-GitlabRunnerJob'
        'Update-GitlabRunner'
        'Suspend-GitlabRunner'
        'Resume-GitlabRunner'
        'Remove-GitlabRunner'
        'Get-GitlabRunnerStats'

        # Search
        'Search-Gitlab'
        'Search-GitlabProject'

        # Snippets
        'Get-GitlabSnippet'
        'Get-GitlabSnippetContent'
        'New-GitlabSnippet'
        'Update-GitlabSnippet'
        'Remove-GitlabSnippet'

        # Todo
        'Get-GitlabTodo'
        'Clear-GitlabTodo'

        # Topics
        'Get-GitlabTopic'
        'New-GitlabTopic'
        'Update-GitlabTopic'
        'Remove-GitlabTopic'
        'Set-GitlabTopicAvatar'
        'Remove-GitlabTopicAvatar'

        # User Deploy Keys
        'Get-GitlabUserDeployKey'

        # User
        'Get-GitlabUser'
        'Get-GitlabCurrentUser'
        'Block-GitlabUser'
        'Remove-GitlabUser'
        'Start-GitlabUserImpersonation'
        'Stop-GitlabUserImpersonation'
        'Use-GitlabToken'
        'Unblock-GitlabUser'

        # Events
        'Get-GitlabUserEvent'
        'Get-GitlabProjectEvent'

        # Integrations
        'Get-GitlabProjectIntegration'
        'Update-GitlabProjectIntegration'
        'Remove-GitlabProjectIntegration'
        'Enable-GitlabProjectSlackNotification'

        # Members
        'Get-GitlabMemberAccessLevel'
        'Get-GitlabMembershipSortKey'

        'Get-GitlabGroupMember'
        'Set-GitlabGroupMember'
        'Add-GitlabGroupMember'
        'Remove-GitlabGroupMember'

        'Get-GitlabProjectMember'
        'Set-GitlabProjectMember'
        'Add-GitlabProjectMember'
        'Remove-GitlabProjectMember'

        'Get-GitlabUserMembership'
        'Add-GitlabUserMembership'
        'Update-GitlabUserMembership'
        'Remove-GitlabUserMembership'

        # Utilities
        'ConvertTo-GitlabVariables'
        'Get-FilteredObject'
        'Get-GitlabVersion'
        'Invoke-GitlabApi'
        'Open-InBrowser'

        # Variables
        'Resolve-GitlabVariable'
    )
    AliasesToExport = @(
        'Add-GitlabIssueNote'
        'Add-GitlabMergeRequestNote'
        'Add-GitlabProjectHook'
        'Archive-GitlabProject'
        'Clone-GitlabGroup'
        'Fork-GitlabProject'
        'Mark-GitlabTodoDone'
        'Play-GitlabJob'
        'Pull-GitlabGroup'
        'Remove-GitlabPersonalAccessToken'
        'Remove-GitlabProjectFork'
        'Remove-GitlabProtectedBranch'
        'Reopen-GitlabIssue'
        'Retry-GitlabJob'
        'Review-GitlabMergeRequest'
        'Revoke-GitlabGroupAccessToken'
        'Revoke-GitlabProjectAccessToken'
        'Revoke-GitlabServiceAccountPersonalAccessToken'
        'Rotate-GitlabPersonalAccessToken'
        'Rotate-GitlabProjectAccessToken'
        'Share-GitlabGroupWithGroup'
        'Share-GitlabProjectWithGroup'
        'Transfer-GitlabGroup'
        'Transfer-GitlabProject'
        'Unarchive-GitlabProject'

        # short form
        'go'
        'tags'
        'labels'
        'build'
        'envs'
        'deploys'
        'pipeline'
        'pipelines'
        'play'
        'schedule'
        'schedules'
        'job'
        'jobs'
        'trace'
        'issue'
        'issues'
        'mr'
        'mrs'
        'var'
    )
}
