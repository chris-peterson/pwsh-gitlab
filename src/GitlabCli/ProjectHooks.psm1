# https://docs.gitlab.com/ee/api/projects.html#hooks
function Get-GitlabProjectHook {
  [CmdletBinding()]
  param (
      [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
      [string]
      $ProjectId = '.',

      [Parameter(Mandatory=$false)]
      [int]
      $Id,

      [Parameter(Mandatory=$false)]
      [string]
      $SiteUrl,

      [switch]
      [Parameter(Mandatory=$false)]
      $WhatIf
  )

  $Project = Get-GitlabProject $ProjectId -SiteUrl $SiteUrl -WhatIf:$WhatIf

  $Resource = "projects/$($Project.Id)/hooks"

  if($Id) {
    $Resource = "$($Resource)/$($Id)"
  }

  Invoke-GitlabApi GET $Resource -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.ProjectHook'
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
      [string]
      $SiteUrl,

      [switch]
      [Parameter(Mandatory=$false)]
      $WhatIf
  )

  $Project = Get-GitlabProject $ProjectId -SiteUrl $SiteUrl -WhatIf:$WhatIf

  $Resource = "projects/$($Project.Id)/hooks"

  Invoke-GitlabApi POST $Resource @{
    id = $Project.Id
    url = $Url
  } -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.ProjectHook'
}

function Remove-GitlabProjectHook {
  [CmdletBinding()]
  param (
      [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
      [string]
      $ProjectId = '.',

      [Parameter(Mandatory=$true)]
      [int]
      $Id,

      [Parameter(Mandatory=$false)]
      [string]
      $SiteUrl,

      [switch]
      [Parameter(Mandatory=$false)]
      $WhatIf
  )

  $Project = Get-GitlabProject $ProjectId -SiteUrl $SiteUrl -WhatIf:$WhatIf

  $Resource = "projects/$($Project.Id)/hooks/$($Id)"

  Invoke-GitlabApi DELETE $Resource -SiteUrl $SiteUrl -WhatIf:$WhatIf
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
    [string]
    $SiteUrl,

    [switch]
    [Parameter(Mandatory=$false)]
    $WhatIf
  )

  $Project = Get-GitlabProject $ProjectId -SiteUrl $SiteUrl -WhatIf:$WhatIf

  $Resource = "projects/$($Project.Id)/hooks/$($Id)"


  Invoke-GitlabApi PUT @{
    url = $Url
  } $Resource -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.ProjectHook'

}