# ============================================================================
# Configuration
# ============================================================================

if($PSVersionTable.Platform -like 'Win*') {
    $env:HOME = Join-Path $env:HOMEDRIVE $env:HOMEPATH
}

$global:GitlabConfigurationPath = Join-Path $env:HOME "/.config/powershell/gitlab.config"

# ============================================================================
# API Defaults
# ============================================================================

$global:GitlabDefaultMaxPages           = 10
$global:GitlabSearchResultsDefaultLimit = 100

# ============================================================================
# Session State
# ============================================================================

$global:GitlabJobLogSections           = New-Object 'Collections.Generic.Stack[string]'
$global:GitlabUserImpersonationSession = $null

# ============================================================================
# Console Colors (ANSI escape codes)
# ============================================================================

$global:GitlabConsoleColors = @{
    Black       = '0;30'
    DarkGray    = '1;30'
    Red         = '0;31'
    LightRed    = '1;31'
    Green       = '0;32'
    LightGreen  = '1;32'
    Orange      = '0;33'
    Yellow      = '1;33'
    Blue        = '0;34'
    LightBlue   = '1;34'
    Purple      = '0;35'
    LightPurple = '1;35'
    Cyan        = '0;36'
    LightCyan   = '1;36'
    LightGray   = '0;37'
    White       = '1;37'
}

# ============================================================================
# Type Identity Property Mappings
# Maps GitLab types to their identity property (empty = no identity property)
# ============================================================================

$global:GitlabIdentityPropertyNameExemptions = @{
    # Access & Authentication
    'Gitlab.AccessToken'               = 'Id'
    'Gitlab.NewPersonalAccessToken'    = 'Id'
    'Gitlab.PersonalAccessToken'       = 'Id'
    'Gitlab.SSHKey'                    = 'Id'

    # Audit & Events
    'Gitlab.AuditEvent'                = 'Id'
    'Gitlab.Event'                     = 'Id'

    # CI/CD - Jobs & Pipelines
    'Gitlab.Job'                       = 'Id'
    'Gitlab.Pipeline'                  = 'Id'
    'Gitlab.PipelineBridge'            = 'Id'
    'Gitlab.PipelineDefinition'        = ''
    'Gitlab.PipelineSchedule'          = 'Id'
    'Gitlab.PipelineScheduleVariable'  = ''
    'Gitlab.PipelineVariable'          = ''

    # CI/CD - Runners
    'Gitlab.Runner'                    = 'Id'
    'Gitlab.RunnerJob'                 = 'Id'
    'Gitlab.RunnerStats'               = ''

    # Configuration
    'Gitlab.Configuration'             = ''
    'Gitlab.Variable'                  = ''

    # Deployments & Environments
    'Gitlab.DeployKey'                 = 'Id'
    'Gitlab.Environment'               = 'Id'

    # Groups & Projects
    'Gitlab.Group'                     = 'Id'
    'Gitlab.Project'                   = 'Id'
    'Gitlab.ProjectHook'               = 'Id'
    'Gitlab.ProjectIntegration'        = 'Id'
    'Gitlab.Topic'                     = 'Id'

    # Merge Requests & Issues
    'Gitlab.MergeRequestApprovalRule'  = 'Id'
    'Gitlab.Milestone'                 = 'Iid'
    'Gitlab.Note'                      = 'Id'
    'Gitlab.Todo'                      = 'Id'

    # Repository
    'Gitlab.Branch'                    = ''
    'Gitlab.Commit'                    = 'Id'
    'Gitlab.ProtectedBranch'           = 'Id'
    'Gitlab.Release'                   = ''
    'Gitlab.RepositoryFile'            = ''
    'Gitlab.RepositoryTree'            = ''
    'Gitlab.Snippet'                   = 'Id'

    # Search Results
    'Gitlab.BlobSearchResult'          = ''
    'Gitlab.SearchResult.Blob'         = ''
    'Gitlab.SearchResult.MergeRequest' = ''
    'Gitlab.SearchResult.Project'      = ''

    # Users & Members
    'Gitlab.Member'                    = 'Id'
    'Gitlab.ServiceAccount'            = 'Id'
    'Gitlab.User'                      = 'Id'
    'Gitlab.UserMembership'            = ''
}
