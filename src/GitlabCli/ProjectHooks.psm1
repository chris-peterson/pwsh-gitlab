# https://docs.gitlab.com/ee/api/projects.html#get-project-hook
function Get-GitlabProjectHook {
  [CmdletBinding()]
  [OutputType('Gitlab.ProjectHook')]
  param (
      [Parameter(ValueFromPipelineByPropertyName)]
      [string]
      $ProjectId = '.',

      [Parameter()]
      [int]
      $Id,

      [Parameter()]
      [string]
      $SiteUrl
  )

  $Project = Get-GitlabProject $ProjectId

  $Resource = "projects/$($Project.Id)/hooks"

  if($Id) {
    $Resource = "$($Resource)/$($Id)"
  }

  Invoke-GitlabApi GET $Resource | New-GitlabObject 'Gitlab.ProjectHook'
}

function New-GitlabProjectHook {
  [CmdletBinding(SupportsShouldProcess)]
  [Alias('Add-GitlabProjectHook')]
  [OutputType('Gitlab.ProjectHook')]
  param (
      [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
      [string]
      $ProjectId = '.',

      [Parameter(Mandatory=$true)]
      [string]
      $Url,

      [Parameter(Mandatory=$false)]
      [TrueOrFalse()][bool]
      $ConfidentialIssuesEvents,

      [Parameter(Mandatory=$false)]
      [TrueOrFalse()][bool]
      $ConfidentialNoteEvents,

      [Parameter(Mandatory=$false)]
      [TrueOrFalse()][bool]
      $DeploymentEvents,
            
      [Parameter(Mandatory=$false)]
      [TrueOrFalse()][bool]
      $EnableSSLVerification,
            
      [Parameter(Mandatory=$false)]
      [TrueOrFalse()][bool]
      $IssuesEvents,
            
      [Parameter(Mandatory=$false)]
      [TrueOrFalse()][bool]
      $JobEvents,
            
      [Parameter(Mandatory=$false)]
      [TrueOrFalse()][bool]
      $MergeRequestsEvents,
            
      [Parameter(Mandatory=$false)]
      [TrueOrFalse()][bool]
      $NoteEvents,
            
      [Parameter(Mandatory=$false)]
      [TrueOrFalse()][bool]
      $PipelineEvents,

      [Parameter(Mandatory=$false)]
      [string]
      $PushEventsBranchFilter,
            
      [Parameter(Mandatory=$false)]
      [TrueOrFalse()][bool]
      $PushEvents,
            
      [Parameter(Mandatory=$false)]
      [TrueOrFalse()][bool]
      $ReleasesEvents,
            
      [Parameter(Mandatory=$false)]
      [TrueOrFalse()][bool]
      $TagPushEvents,

      [Parameter(Mandatory=$false)]
      [string]
      $Token,
            
      [Parameter(Mandatory=$false)]
      [TrueOrFalse()][bool]
      $WikiPageEvents,

      [Parameter(Mandatory=$false)]
      [string]
      $SiteUrl
  )

  $Project = Get-GitlabProject $ProjectId

  $Resource = "projects/$($Project.Id)/hooks"

  $Request = @{
    url = $Url
    confidential_issues_events = $ConfidentialIssuesEvents
    confidential_note_events = $ConfidentialNoteEvents
    deployment_events = $DeploymentEvents
    enable_ssl_verification = $EnableSSLVerification
    issues_events = $IssuesEvents
    job_events = $JobEvents
    merge_requests_events = $MergeRequestsEvents
    note_events = $NoteEvents
    pipeline_events = $PipelineEvents
    push_events = $PushEvents
    releases_events = $ReleasesEvents
    tag_push_events = $TagPushEvents
    wiki_page_events = $WikiPageEvents
  }

  if($PushEventsBranchFilter) {
    $Request += @{
      push_events_branch_filter = $PushEventsBranchFilter
    }
  }

  if($Token) {
    $Request += @{
      token = $Token
    }
  }

  if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "create webhook to $Url")) {
    Invoke-GitlabApi POST $Resource @Request | New-GitlabObject 'Gitlab.ProjectHook'
  }
}

function Update-GitlabProjectHook {
  [CmdletBinding(SupportsShouldProcess)]
  [OutputType('Gitlab.ProjectHook')]
  param (
    [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
    [string]
    $ProjectId = '.',

    [Parameter(Mandatory=$true)]
    [int]
    $Id,

    [Parameter(Mandatory=$true)]
    [string]
    $Url,

    [Parameter(Mandatory=$false)]
    [TrueOrFalse()][bool]
    $ConfidentialIssuesEvents,

    [Parameter(Mandatory=$false)]
    [TrueOrFalse()][bool]
    $ConfidentialNoteEvents,

    [Parameter(Mandatory=$false)]
    [TrueOrFalse()][bool]
    $DeploymentEvents,
          
    [Parameter(Mandatory=$false)]
    [TrueOrFalse()][bool]
    $EnableSSLVerification,
          
    [Parameter(Mandatory=$false)]
    [TrueOrFalse()][bool]
    $IssuesEvents,
          
    [Parameter(Mandatory=$false)]
    [TrueOrFalse()][bool]
    $JobEvents,
          
    [Parameter(Mandatory=$false)]
    [TrueOrFalse()][bool]
    $MergeRequestsEvents,
          
    [Parameter(Mandatory=$false)]
    [TrueOrFalse()][bool]
    $NoteEvents,
          
    [Parameter(Mandatory=$false)]
    [TrueOrFalse()][bool]
    $PipelineEvents,

    [Parameter(Mandatory=$false)]
    [string]
    $PushEventsBranchFilter,
          
    [Parameter(Mandatory=$false)]
    [TrueOrFalse()][bool]
    $PushEvents,
          
    [Parameter(Mandatory=$false)]
    [TrueOrFalse()][bool]
    $ReleasesEvents,
          
    [Parameter(Mandatory=$false)]
    [TrueOrFalse()][bool]
    $TagPushEvents,

    [Parameter(Mandatory=$false)]
    [string]
    $Token,
          
    [Parameter(Mandatory=$false)]
    [TrueOrFalse()][bool]
    $WikiPageEvents,

    [Parameter(Mandatory=$false)]
    [string]
    $SiteUrl
  )

  $Project = Get-GitlabProject $ProjectId

  $Resource = "projects/$($Project.Id)/hooks/$($Id)"

  $Request = @{
    url = $Url
    confidential_issues_events = $ConfidentialIssuesEvents
    confidential_note_events = $ConfidentialNoteEvents
    deployment_events = $DeploymentEvents
    enable_ssl_verification = $EnableSSLVerification
    issues_events = $IssuesEvents
    job_events = $JobEvents
    merge_requests_events = $MergeRequestsEvents
    note_events = $NoteEvents
    pipeline_events = $PipelineEvents
    push_events = $PushEvents
    releases_events = $ReleasesEvents
    tag_push_events = $TagPushEvents
    wiki_page_events = $WikiPageEvents
  }

  if($PushEventsBranchFilter) {
    $Request += @{
      push_events_branch_filter = $PushEventsBranchFilter
    }
  }

  if($Token) {
    $Request += @{
      token = $Token
    }
  }
  
  if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace) hook #$Id", "update webhook")) {
    Invoke-GitlabApi PUT $Resource $Request | New-GitlabObject 'Gitlab.ProjectHook'
  }
}

# https://docs.gitlab.com/ee/api/projects.html#delete-project-hook
function Remove-GitlabProjectHook {
  [CmdletBinding(SupportsShouldProcess)]
  [OutputType([void])]
  param (
      [Parameter(ValueFromPipelineByPropertyName)]
      [string]
      $ProjectId = '.',

      [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
      [Alias('Id')]
      [int]
      $HookId,

      [Parameter()]
      [string]
      $SiteUrl
  )

  $Project = Get-GitlabProject $ProjectId

  $Resource = "projects/$($Project.Id)/hooks/$($HookId)"

  if ($PSCmdlet.ShouldProcess($Resource, 'delete')) {
    Invoke-GitlabApi DELETE $Resource | Out-Null
    Write-Host "Removed project hook ($HookId) from $($Project.PathWithNamespace)"
  }
}
