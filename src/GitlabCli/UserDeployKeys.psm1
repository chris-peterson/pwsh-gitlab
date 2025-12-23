function Get-GitlabUserDeployKey {
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName,Position=0)]
        [string]
        $UserId,

        [Parameter()]
        [string]
        $SiteUrl
    ) 

    $User = Get-GitlabUser -UserId $UserId

    $GitlabAPIParams = @{
        Method = 'Get'
        Path   = "users/$($User.Id)/project_deploy_keys"
    }

    Invoke-GitlabApi @GitlabAPIParams -Verbose:$VerbosePreference | New-WrapperObject 'Gitlab.DeployKey'
}