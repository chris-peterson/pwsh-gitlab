@{
    ModuleVersion = '1.162.0'

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
* feat: Get-GitLabIssue by Assignee (-Mine uses this now)
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
        'Private/Functions/BranchHelpers.ps1'
        'Private/Functions/CacheHelpers.ps1'
        'Private/Functions/StringHelpers.ps1'
        'Private/Functions/ConfigurationHelpers.ps1'
        'Private/Functions/GroupHelpers.ps1'
        'Private/Functions/JobHelpers.ps1'
        'Private/Functions/MergeRequestHelpers.ps1'
        'Private/Functions/ObjectHelpers.ps1'
        'Private/Functions/PaginationHelpers.ps1'
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
        'Development.psm1'
        'Environments.psm1'
        'Git.psm1'
        'GraphQL.psm1'
        'GroupAccessTokens.psm1'
        'Groups.psm1'
        'Integrations.psm1'
        'Issues.psm1'
        'Jobs.psm1'
        'Keys.psm1'
        'Members.psm1'
        'MergeRequests.psm1'
        'Milestones.psm1'
        'Notes.psm1'
        'PersonalAccessTokens.psm1'
        'Pipelines.psm1'
        'PipelineSchedules.psm1'
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
        'Todos.psm1'
        'Topics.psm1'
        'UserDeployKeys.psm1'
        'Users.psm1'
        'Utilities.psm1'
        'Variables.psm1'
    )
    FunctionsToExport = @(
        # AuditEvents.psm1
        'Get-GitlabAuditEvent'

        # Branches.psm1
        'Get-GitlabBranch'
        'Get-GitlabProtectedBranch'
        'New-GitlabBranch'
        'Protect-GitlabBranch'
        'Remove-GitlabBranch'
        'UnProtect-GitlabBranch'

        # Commits.psm1
        'Get-GitlabCommit'

        # Config.psm1
        'Add-GitlabSite'
        'Get-DefaultGitlabSite'
        'Get-GitlabConfiguration'
        'Remove-GitlabSite'
        'Set-DefaultGitlabSite'

        # DeployKeys.psm1
        'Get-GitlabDeployKey'

        # Development.psm1
        'Initialize-GitlabDevelopment'

        # Deployments.psm1
        'Get-GitlabDeployment'

        # Environments.psm1
        'Get-GitlabEnvironment'
        'Remove-GitlabEnvironment'
        'Stop-GitlabEnvironment'

        # Git.psm1
        'Get-LocalGitContext'

        # GraphQL.psm1
        'Invoke-GitlabGraphQL'

        # GroupAccessTokens.psm1
        'Get-GitlabGroupAccessToken'
        'New-GitlabGroupAccessToken'
        'Remove-GitlabGroupAccessToken'

        # Groups.psm1
        'Copy-GitlabGroupToLocalFileSystem'
        'Get-GitlabGroup'
        'Get-GitlabGroupVariable'
        'Move-GitlabGroup'
        'New-GitlabGroup'
        'New-GitlabGroupToGroupShare'
        'Remove-GitlabGroup'
        'Remove-GitlabGroupToGroupShare'
        'Remove-GitlabGroupVariable'
        'Rename-GitlabGroup'
        'Set-GitlabGroupVariable'
        'Update-GitlabGroup'
        'Update-LocalGitlabGroup'

        # Integrations.psm1
        'Enable-GitlabProjectSlackNotification'
        'Get-GitlabProjectIntegration'
        'Remove-GitlabProjectIntegration'
        'Update-GitlabProjectIntegration'

        # Issues.psm1
        'Close-GitlabIssue'
        'Get-GitlabIssue'
        'New-GitlabIssue'
        'Open-GitlabIssue'
        'Update-GitlabIssue'

        # Jobs.psm1
        'Get-GitlabJob'
        'Get-GitlabJobArtifact'
        'Get-GitlabJobTrace'
        'Get-GitlabPipelineDefinition'
        'Start-GitlabJob'
        'Start-GitlabJobLogSection'
        'Stop-GitlabJobLogSection'
        'Test-GitlabPipelineDefinition'
        'Write-GitlabJobTrace'

        # Keys.psm1
        'Get-GitlabKey'

        # Members.psm1
        'Add-GitlabGroupMember'
        'Add-GitlabProjectMember'
        'Add-GitlabUserMembership'
        'Get-GitlabGroupMember'
        'Get-GitlabMemberAccessLevel'
        'Get-GitlabMembershipSortKey'
        'Get-GitlabProjectMember'
        'Get-GitlabUserMembership'
        'Remove-GitlabGroupMember'
        'Remove-GitlabProjectMember'
        'Remove-GitlabUserMembership'
        'Set-GitlabGroupMember'
        'Set-GitlabProjectMember'
        'Update-GitlabUserMembership'

        # MergeRequests.psm1
        'Approve-GitlabMergeRequest'
        'Close-GitlabMergeRequest'
        'Get-GitlabMergeRequest'
        'Get-GitlabMergeRequestApprovalConfiguration'
        'Get-GitlabMergeRequestApprovalRule'
        'Invoke-GitlabMergeRequestReview'
        'Merge-GitlabMergeRequest'
        'New-GitlabMergeRequest'
        'New-GitlabMergeRequestApprovalRule'
        'Remove-GitlabMergeRequestApprovalRule'
        'Set-GitlabMergeRequest'
        'Update-GitlabMergeRequest'
        'Update-GitlabMergeRequestApprovalConfiguration'

        # Milestones.psm1
        'Get-GitlabMilestone'

        # Notes.psm1
        'Get-GitlabIssueNote'
        'Get-GitlabMergeRequestNote'
        'New-GitlabIssueNote'

        # PersonalAccessTokens.psm1
        'Get-GitlabPersonalAccessToken'
        'Invoke-GitlabPersonalAccessTokenRotation'
        'New-GitlabPersonalAccessToken'
        'Revoke-GitlabPersonalAccessToken'

        # PipelineSchedules.psm1
        'Disable-GitlabPipelineSchedule'
        'Enable-GitlabPipelineSchedule'
        'Get-GitlabPipelineSchedule'
        'Get-GitlabPipelineScheduleVariable'
        'New-GitlabPipelineSchedule'
        'New-GitlabPipelineScheduleVariable'
        'New-GitlabScheduledPipeline'
        'Remove-GitlabPipelineSchedule'
        'Remove-GitlabPipelineScheduleVariable'
        'Update-GitlabPipelineSchedule'
        'Update-GitlabPipelineScheduleVariable'

        # Pipelines.psm1
        'Get-GitlabPipeline'
        'Get-GitlabPipelineBridge'
        'Get-GitlabPipelineVariable'
        'New-GitlabPipeline'
        'Remove-GitlabPipeline'

        # ProjectAccessTokens.psm1
        'Get-GitlabProjectAccessToken'
        'Invoke-GitlabProjectAccessTokenRotation'
        'New-GitlabProjectAccessToken'
        'Remove-GitlabProjectAccessToken'

        # ProjectDeployKeys.psm1
        'Add-GitlabProjectDeployKey'
        'Enable-GitlabProjectDeployKey'
        'Get-GitlabProjectDeployKey'
        'Remove-GitlabProjectDeployKey'
        'Update-GitlabProjectDeployKey'

        # ProjectHooks.psm1
        'Get-GitlabProjectHook'
        'New-GitlabProjectHook'
        'Remove-GitlabProjectHook'
        'Update-GitlabProjectHook'

        # Projects.psm1
        'Add-GitlabProjectTopic'
        'ConvertTo-GitlabTriggerYaml'
        'Copy-GitlabProject'
        'Copy-GitlabProjectToLocalFileSystem'
        'Get-GitlabProject'
        'Get-GitlabProjectEvent'
        'Get-GitlabProjectVariable'
        'Invoke-GitlabProjectArchival'
        'Invoke-GitlabProjectUnarchival'
        'Move-GitlabProject'
        'New-GitlabGroupToProjectShare'
        'New-GitlabProject'
        'Remove-GitlabGroupToProjectShare'
        'Remove-GitlabProject'
        'Remove-GitlabProjectForkRelationship'
        'Remove-GitlabProjectTopic'
        'Remove-GitlabProjectVariable'
        'Rename-GitlabProject'
        'Rename-GitlabProjectDefaultBranch'
        'Set-GitlabProjectVariable'
        'Update-GitlabProject'

        # Releases.psm1
        'Get-GitlabRelease'

        # RepositoryFiles.psm1
        'Get-GitlabRepositoryFile'
        'Get-GitlabRepositoryFileContent'
        'Get-GitlabRepositoryTree'
        'Get-GitlabRepositoryYmlFileContent'
        'New-GitlabRepositoryFile'
        'Update-GitlabRepositoryFile'

        # Runners.psm1
        'Get-GitlabRunner'
        'Get-GitlabRunnerJob'
        'Get-GitlabRunnerStats'
        'Remove-GitlabRunner'
        'Resume-GitlabRunner'
        'Suspend-GitlabRunner'
        'Update-GitlabRunner'

        # Search.psm1
        'Search-Gitlab'
        'Search-GitlabProject'

        # ServiceAccounts.psm1
        'Get-GitlabServiceAccount'
        'New-GitlabServiceAccount'
        'Remove-GitlabServiceAccount'
        'Update-GitlabServiceAccount'

        # Snippets.psm1
        'Get-GitlabSnippet'
        'Get-GitlabSnippetContent'
        'New-GitlabSnippet'
        'Remove-GitlabSnippet'
        'Update-GitlabSnippet'

        # Todos.psm1
        'Clear-GitlabTodo'
        'Get-GitlabTodo'

        # Topics.psm1
        'Get-GitlabTopic'
        'New-GitlabTopic'
        'Remove-GitlabTopic'
        'Update-GitlabTopic'

        # UserDeployKeys.psm1
        'Get-GitlabUserDeployKey'

        # Users.psm1
        'Block-GitlabUser'
        'Get-GitlabCurrentUser'
        'Get-GitlabUser'
        'Get-GitlabUserEvent'
        'Remove-GitlabUser'
        'Start-GitlabUserImpersonation'
        'Stop-GitlabUserImpersonation'
        'Unblock-GitlabUser'

        # Utilities.psm1
        'Get-FilteredObject'
        'Get-GitlabVersion'
        'Invoke-GitlabApi'
        'Open-InBrowser'

        # Variables.psm1
        'ConvertTo-GitlabVariables'
        'Resolve-GitlabVariable'
    )
    AliasesToExport = @(
        'Add-GitlabIssueNote'
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
        'Rotate-GitlabPersonalAccessToken'
        'Rotate-GitlabProjectAccessToken'
        'Share-GitlabGroupWithGroup'
        'Share-GitlabProjectWithGroup'
        'Transfer-GitlabGroup'
        'Transfer-GitlabProject'
        'Unarchive-GitlabProject'

        # short form
        'build'
        'deploys'
        'dev'
        'envs'
        'go'
        'issue'
        'issues'
        'job'
        'jobs'
        'mr'
        'mrs'
        'pipeline'
        'pipelines'
        'play'
        'schedule'
        'schedules'
        'trace'
        'var'
    )
}
