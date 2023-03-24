# https://docs.gitlab.com/ee/api/projects.html#get-project-hook
function Get-GitlabProjectHook {
  [CmdletBinding()]
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

  $Project = Get-GitlabProject $ProjectId -SiteUrl $SiteUrl

  $Resource = "projects/$($Project.Id)/hooks"

  if($Id) {
    $Resource = "$($Resource)/$($Id)"
  }

  Invoke-GitlabApi GET $Resource -SiteUrl $SiteUrl | New-WrapperObject 'Gitlab.ProjectHook'
}

function New-GitlabProjectHook {
  [CmdletBinding()]
  [Alias('Add-GitlabProjectHook')]
  param (
      [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
      [string]
      $ProjectId = '.',

      [Parameter(Mandatory=$true)]
      [string]
      $Url,

      [Parameter(Mandatory=$false)]
      [bool]
      $ConfidentialIssuesEvents,

      [Parameter(Mandatory=$false)]
      [bool]
      $ConfidentialNoteEvents,

      [Parameter(Mandatory=$false)]
      [bool]
      $DeploymentEvents,
            
      [Parameter(Mandatory=$false)]
      [bool]
      $EnableSSLVerification,
            
      [Parameter(Mandatory=$false)]
      [bool]
      $IssuesEvents,
            
      [Parameter(Mandatory=$false)]
      [bool]
      $JobEvents,
            
      [Parameter(Mandatory=$false)]
      [bool]
      $MergeRequestsEvents,
            
      [Parameter(Mandatory=$false)]
      [bool]
      $NoteEvents,
            
      [Parameter(Mandatory=$false)]
      [bool]
      $PipelineEvents,

      [Parameter(Mandatory=$false)]
      [string]
      $PushEventsBranchFilter,
            
      [Parameter(Mandatory=$false)]
      [bool]
      $PushEvents,
            
      [Parameter(Mandatory=$false)]
      [bool]
      $ReleasesEvents,
            
      [Parameter(Mandatory=$false)]
      [bool]
      $TagPushEvents,

      [Parameter(Mandatory=$false)]
      [string]
      $Token,
            
      [Parameter(Mandatory=$false)]
      [bool]
      $WikiPageEvents,

      [Parameter(Mandatory=$false)]
      [string]
      $SiteUrl,

      [switch]
      [Parameter(Mandatory=$false)]
      $WhatIf
  )

  $Project = Get-GitlabProject $ProjectId -SiteUrl $SiteUrl -WhatIf:$WhatIf

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

  Invoke-GitlabApi POST $Resource @Request -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.ProjectHook'
}

function Update-GitlabProjectHook {
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
    [bool]
    $ConfidentialIssuesEvents,

    [Parameter(Mandatory=$false)]
    [bool]
    $ConfidentialNoteEvents,

    [Parameter(Mandatory=$false)]
    [bool]
    $DeploymentEvents,
          
    [Parameter(Mandatory=$false)]
    [bool]
    $EnableSSLVerification,
          
    [Parameter(Mandatory=$false)]
    [bool]
    $IssuesEvents,
          
    [Parameter(Mandatory=$false)]
    [bool]
    $JobEvents,
          
    [Parameter(Mandatory=$false)]
    [bool]
    $MergeRequestsEvents,
          
    [Parameter(Mandatory=$false)]
    [bool]
    $NoteEvents,
          
    [Parameter(Mandatory=$false)]
    [bool]
    $PipelineEvents,

    [Parameter(Mandatory=$false)]
    [string]
    $PushEventsBranchFilter,
          
    [Parameter(Mandatory=$false)]
    [bool]
    $PushEvents,
          
    [Parameter(Mandatory=$false)]
    [bool]
    $ReleasesEvents,
          
    [Parameter(Mandatory=$false)]
    [bool]
    $TagPushEvents,

    [Parameter(Mandatory=$false)]
    [string]
    $Token,
          
    [Parameter(Mandatory=$false)]
    [bool]
    $WikiPageEvents,

    [Parameter(Mandatory=$false)]
    [string]
    $SiteUrl,

    [switch]
    [Parameter(Mandatory=$false)]
    $WhatIf
  )

  $Project = Get-GitlabProject $ProjectId -SiteUrl $SiteUrl -WhatIf:$WhatIf

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
  
  Invoke-GitlabApi PUT $UpdateRequest $Resource -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.ProjectHook'
}

# https://docs.gitlab.com/ee/api/projects.html#delete-project-hook
function Remove-GitlabProjectHook {
  [CmdletBinding(SupportsShouldProcess)]
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

  $Project = Get-GitlabProject $ProjectId -SiteUrl $SiteUrl

  $Resource = "projects/$($Project.Id)/hooks/$($HookId)"

  if ($PSCmdlet.ShouldProcess($Resource, 'delete')) {
    Invoke-GitlabApi DELETE $Resource -SiteUrl $SiteUrl | Out-Null
    Write-Host "Removed project hook ($HookId) from $($Project.PathWithNamespace)"
  }
}
