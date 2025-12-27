function Get-GitlabUserDeployKey {
    [CmdletBinding()]
    [OutputType('Gitlab.DeployKey')]
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

    Invoke-GitlabApi @GitlabAPIParams -Verbose:$VerbosePreference | New-GitlabObject 'Gitlab.DeployKey'
}