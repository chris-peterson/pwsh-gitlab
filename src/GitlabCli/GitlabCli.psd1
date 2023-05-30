@{
    ModuleVersion = '1.97.3'

    PrivateData = @{
        PSData = @{
            LicenseUri = 'https://github.com/chris-peterson/pwsh-gitlab/blob/main/LICENSE'
            ProjectUri = 'https://github.com/chris-peterson/pwsh-gitlab'
            ReleaseNotes = 'Standardize more cmdlets'
        }
    }

    GUID = '220fdbee-bea7-4951-9375-f6e76bd981b4'

    Author = 'Chris Peterson'
    CompanyName = 'Chris Peterson'
    Copyright = '(c) 2021-2023'

    Description = 'Interact with GitLab via PowerShell'
    PowerShellVersion = '7.1'

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
        'Notes.psm1'
        'Pipelines.psm1'
        'Projects.psm1'
        'ProjectHooks.psm1'
        'RepositoryFiles.psm1'
        'Runners.psm1'
        'Search.psm1'
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
        'Get-GitlabGroup'
        'New-GitlabGroup'
        'Remove-GitlabGroup'
        'Rename-GitlabGroup'
        'Move-GitlabGroup'
        'Copy-GitlabGroupToLocalFileSystem'
        'Update-GitlabGroup'
        'Update-LocalGitlabGroup'
        'Get-GitlabGroupVariable'
        'Set-GitlabGroupVariable'
        'Remove-GitlabGroupVariable'
        'New-GitlabGroupShareLink'
        'Remove-GitlabGroupShareLink'

        # Projects
        'Get-GitlabProject'
        'ConvertTo-GitlabTriggerYaml'
        'New-GitlabProject'
        'Update-GitlabProject'
        'Move-GitlabProject'
        'Rename-GitlabProject'
        'Rename-GitlabProjectDefaultBranch'
        'Copy-GitlabProject'
        'Invoke-GitlabProjectArchival'
        'Invoke-GitlabProjectUnarchival'
        'Get-GitlabProjectVariable'
        'Set-GitlabProjectVariable'
        'Remove-GitlabProjectVariable'
        'Get-GitlabProjectHook'
        'Remove-GitlabProjectHook'
        'Update-GitlabProjectHook'
        'New-GitlabProjectHook'

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
        
        # Pipelines
        'Get-GitlabPipeline'
        'Get-GitlabPipelineVariable'
        'New-GitlabPipeline'
        'Remove-GitlabPipeline'
        'Get-GitlabPipelineSchedule'
        'New-GitlabPipelineSchedule'
        'Update-GitlabPipelineSchedule'
        'Enable-GitlabPipelineSchedule'
        'Disable-GitlabPipelineSchedule'
        'Remove-GitlabPipelineSchedule'
        'Get-GitlabPipelineScheduleVariable'
        'New-GitlabPipelineScheduleVariable'
        'Remove-GitlabPipelineScheduleVariable'
        'Update-GitlabPipelineScheduleVariable'
        'New-GitlabScheduledPipeline'
        'Get-GitlabPipelineBridge'

        # Jobs
        'Get-GitlabJob'
        'Get-GitlabJobTrace'
        'Start-GitlabJob'
        'Get-GitlabPipelineDefinition'
        'Test-GitlabPipelineDefinition'
        'Start-GitlabJobLogSection'
        'Stop-GitlabJobLogSection'
        'Write-GitlabJobTrace'

        # Runners
        'Get-GitlabRunner'
        'Get-GitlabRunnerJobs'
        'Update-GitlabRunner'
        'Suspend-GitlabRunner'
        'Resume-GitlabRunner'
        'Remove-GitlabRunner'

        # Search
        'Search-Gitlab'
        'Search-GitlabProject'

        # Topics
        'Get-GitlabTopic'
        'New-GitlabTopic'
        'Update-GitlabTopic'
        'Remove-GitlabTopic'

        # User
        'Get-GitlabUser'
        'Get-GitlabCurrentUser'

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

        'Get-GitlabGroupMember'
        'Add-GitlabGroupMember'
        'Remove-GitlabGroupMember'

        'Get-GitlabProjectMember'
        'Add-GitlabProjectMember'
        'Remove-GitlabProjectMember'

        'Get-GitlabUserMembership'
        'Add-GitlabUserMembership'
        'Update-GitlabUserMembership'

        # Utilities
        'ConvertTo-PascalCase'
        'ConvertTo-SnakeCase'
        'ConvertTo-UrlEncoded'
        'Get-FilteredObject'
        'Get-GitlabVersion'
        'Invoke-GitlabApi'
        'New-WrapperObject'
        'Open-InBrowser'
        'ValidateGitlabDateFormat'

        # Variables
        'Resolve-GitlabVariable'
    )
    AliasesToExport = @(
        # long form
        'Clone-GitlabGroup'
        'Pull-GitlabGroup'
        'Transfer-GitlabGroup'
        'Transfer-GitlabProject'
        'Fork-GitlabProject'
        'Archive-GitlabProject'
        'Unarchive-GitlabProject'
        'Review-GitlabMergeRequest'
        'Play-GitlabJob'
        'Revoke-GitlabGroupAccessToken'

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
