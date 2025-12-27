function Get-GitlabDeployKey {
  [OutputType('Gitlab.DeployKey')]
  [CmdletBinding()]
  param(
    [Parameter()]
    [ValidateNotNullOrWhiteSpace()]
    [string]
    $DeployKeyId,

    [Parameter()]
    [string]
    $SiteUrl
  )

  $Request = @{
      Method = 'GET'
      Path   = "deploy_keys"
  }

  if ($DeployKeyId) {
      $Request.Path += "/$DeployKeyId"
  }

  Invoke-GitlabApi @Request | New-GitlabObject 'Gitlab.DeployKey'
}
