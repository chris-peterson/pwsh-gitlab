@{
    ModuleVersion = '1.131.0'

    RequiredModules = @(
        @{
            ModuleName = 'powershell-yaml'
            RequiredVersion = '0.4.12'
        }
    )

    PrivateData = @{
        PSData = @{
            LicenseUri = 'https://github.com/chris-peterson/pwsh-gitlab/blob/main/LICENSE'
            ProjectUri = 'https://github.com/chris-peterson/pwsh-gitlab'
            IconUri = 'https://raw.githubusercontent.com/chris-peterson/pwsh-gitlab/main/assets/icon.png'
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
* switch [publishing mechanism](https://github.com/marketplace/actions/publish-powershell-modules)
'@
        }
    }

    GUID = '220fdbee-bea7-4951-9375-f6e76bd981b4'

    Author = 'Chris Peterson'
    CompanyName = 'Chris Peterson'
    Copyright = '(c) 2021-2025'

    Description = 'Interact with GitLab via PowerShell'
    PowerShellVersion = '7.1'
    CompatiblePSEditions = @('Core', 'Desktop')

    ScriptsToProcess = @('_Init.ps1')
    TypesToProcess = @('Types.ps1xml')
    FormatsToProcess = @('Formats.ps1xml')

    NestedModules = @(
        'AuditEvents.psm1'
        'Branches.psm1'
        'Commits.psm1'
        'Config.psm1'
        'Deployments.psm1'
        'Environments.psm1'
        'Git.psm1'
        'GraphQL.psm1'
        'GroupAccessTokens.psm1'
        'Groups.psm1'
        'Integrations.psm1'
        'Issues.psm1'
        'Jobs.psm1'
        'Members.psm1'
        'MergeRequests.psm1'
        'Milestones.psm1'
        'Notes.psm1'
        'PersonalAccessTokens.psm1'
        'Pipelines.psm1'
        'PipelineSchedules.psm1'
        'Projects.psm1'
        'ProjectHooks.psm1'
        'RepositoryFiles.psm1'
        'Releases.psm1'
        'Runners.psm1'
        'Search.psm1'
        'Todos.psm1'
        'Topics.psm1'
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
        'Get-GitlabProtectedBranchAccessLevel'

        # Commits
        'Get-GitlabCommit'

        # Configuration
        'Get-GitlabConfiguration'
        'Add-GitlabSite'
        'Remove-GitlabSite'
        'Get-DefaultGitlabSite'
        'Set-DefaultGitlabSite'

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
        'Remove-GitlabGroupToGroupShare'
        'Remove-GitlabGroupVariable'
        'Rename-GitlabGroup'
        'Set-GitlabGroupVariable'
        'Update-GitlabGroup'
        'Update-LocalGitlabGroup'

        # Projects
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
        'Remove-GitlabProjectForkRelationship'
        'Remove-GitlabProjectHook'
        'Remove-GitlabProjectVariable'
        'Rename-GitlabProject'
        'Rename-GitlabProjectDefaultBranch'
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
        'Get-GitlabMergeRequestNote'

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
        'Get-GitlabMergeRequestApprovalConfiguration'
        'Update-GitlabMergeRequestApprovalConfiguration'
        'Get-GitlabMergeRequestApprovalRule'
        'New-GitlabMergeRequestApprovalRule'
        'Remove-GitlabMergeRequestApprovalRule'

        # Milestones
        'Get-GitlabMilestone'

        # PATs
        'Get-GitlabPersonalAccessToken'
        'New-GitlabPersonalAccessToken'
        'Invoke-GitlabPersonalAccessTokenRotation'
        'Revoke-GitlabPersonalAccessToken'

        # Pipelines
        'Get-GitlabPipeline'
        'Get-GitlabPipelineVariable'
        'New-GitlabPipeline'
        'Remove-GitlabPipeline'
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

        # Jobs
        'Get-GitlabJob'
        'Get-GitlabJobTrace'
        'Start-GitlabJob'
        'Get-GitlabPipelineDefinition'
        'Test-GitlabPipelineDefinition'
        'Start-GitlabJobLogSection'
        'Stop-GitlabJobLogSection'
        'Write-GitlabJobTrace'

        # Releases
        'Get-GitlabRelease'

        # Runners
        'Get-GitlabRunner'
        'Get-GitlabRunnerJob'
        'Update-GitlabRunner'
        'Suspend-GitlabRunner'
        'Resume-GitlabRunner'
        'Remove-GitlabRunner'

        # Search
        'Search-Gitlab'
        'Search-GitlabProject'

        # Todo
        'Get-GitlabTodo'
        'Clear-GitlabTodo'

        # Topics
        'Get-GitlabTopic'
        'New-GitlabTopic'
        'Update-GitlabTopic'
        'Remove-GitlabTopic'

        # User
        'Get-GitlabUser'
        'Get-GitlabCurrentUser'
        'Block-GitlabUser'
        'Start-GitlabUserImpersonation'
        'Stop-GitlabUserImpersonation'
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
        'ConvertTo-PascalCase'
        'ConvertTo-SnakeCase'
        'ConvertTo-UrlEncoded'
        'ConvertTo-GitlabVariables'
        'Get-FilteredObject'
        'Get-GitlabMaxPages'
        'Get-GitlabVersion'
        'Invoke-GitlabApi'
        'New-WrapperObject'
        'Open-InBrowser'
        'ValidateGitlabDateFormat'
        'Get-GitlabResourceFromUrl'

        # Variables
        'Resolve-GitlabVariable'
    )
    AliasesToExport = @(
        'Add-GitlabIssueNote'
        'Archive-GitlabProject'
        'Clone-GitlabGroup'
        'Fork-GitlabProject'
        'Play-GitlabJob'
        'Pull-GitlabGroup'
        'Remove-GitlabPersonalAccessToken'
        'Remove-GitlabProjectFork'
        'Remove-GitlabProtectedBranch'
        'Retry-GitlabJob'
        'Review-GitlabMergeRequest'
        'Revoke-GitlabGroupAccessToken'
        'Rotate-GitlabPersonalAccessToken'
        'Share-GitlabGroupWithGroup'
        'Share-GitlabProjectWithGroup'
        'Transfer-GitlabGroup'
        'Transfer-GitlabProject'
        'Unarchive-GitlabProject'

        # short form
        'go'
        'build'
        'envs'
        'deploys'
        'pipeline'
        'pipelines'
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
