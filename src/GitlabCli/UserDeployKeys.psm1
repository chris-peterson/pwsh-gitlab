function Get-GitlabUserDeployKey {
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName,Position=0)]
        [string]
        $UserId,

        [Parameter()]
        [string]
        $SiteUrl
    ) 

    $User = Get-GitlabUser -UserId $UserId -SiteUrl $SiteUrl

    $GitlabAPIParams = @{
        Method = 'Get'
        Path   = "users/$($User.Id)/project_deploy_keys"
    }

    Invoke-GitlabApi @GitlabAPIParams -SiteUrl $SiteUrl -Verbose:$VerbosePreference | New-WrapperObject 'Gitlab.DeployKey'
}