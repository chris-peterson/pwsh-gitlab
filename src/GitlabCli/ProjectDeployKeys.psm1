function Get-GitlabProjectDeployKey {
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName,Position=0)]
        [string]
        $ProjectId,

        [Parameter()]
        [string]
        $DeployKeyId,

        [Parameter()]
        [string]
        $SiteUrl
    ) 

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $GitlabAPIParams = @{
        Method = 'Get'
        Path   = "projects/$($Project.Id)/deploy_keys"
    }

    if($PSBoundParameters.ContainsKey('DeployKeyId')) {
        $GitlabAPIParams.Path += "/$DeployKeyId"
    }

    Invoke-GitlabApi @GitlabAPIParams -Verbose:$VerbosePreference | New-WrapperObject 'Gitlab.DeployKey'
}

function Add-GitlabProjectDeployKey {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName,Position=0)]
        [string]
        $ProjectId,

        [Parameter(Mandatory)]
        [string]
        $Title,

        [Parameter(Mandatory)]
        [string]
        $Key,

        [Parameter()]
        [switch]
        $CanPush,

        [Parameter()]
        [string]
        $SiteUrl
    ) 

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $Body = @{
        title    = $Title
        key      = $Key
        can_push = $CanPush.IsPresent
    }

    $GitlabAPIParams = @{
        Method = 'POST'
        Path   = "projects/$($Project.Id)/deploy_keys"
        Body   = $Body
    }

    if ($PSCmdlet.ShouldProcess("$($Project.PathWithNamespace)", "add deploy key '$Title'")) {
        Invoke-GitlabApi @GitlabAPIParams -Verbose:$VerbosePreference | New-WrapperObject 'Gitlab.DeployKey'
    }
}

function Update-GitlabProjectDeployKey {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName,Position=0)]
        [string]
        $ProjectId,

        [Parameter(Mandatory)]
        [string]
        $DeployKeyId,

        [Parameter()]
        [string]
        $Title,

        [Parameter()]
        [boolean]
        $CanPush,

        [Parameter()]
        [string]
        $SiteUrl,

        [Parameter()]
        [switch]
        $Force
    ) 

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $Body = @{
    }

    if($PSBoundParameters.ContainsKey('CanPush')) {
        $Body.can_push = $CanPush
    }

    $GitlabAPIParams = @{
        Method = 'PUT'
        Path   = "projects/$($Project.Id)/deploy_keys/$DeployKeyId"
        Body   = $Body
    }

    # https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-shouldprocess?view=powershell-7.5#implementing--force
    if ($Force -and -not $PSBoundParameters.ContainsKey('Confirm')) {
        $ConfirmPreference = 'None'
    }
    

    if($PSCmdlet.ShouldProcess("Update deploy key for project '$($Project.PathWithNamespace)'","Update-GitlabProjectDeployKey")) {
        Invoke-GitlabApi @GitlabAPIParams -Verbose:$VerbosePreference -WhatIf:$WhatIfPreference | New-WrapperObject 'Gitlab.DeployKey'
    }
}

function Remove-GitlabProjectDeployKey {
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact='High')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName,Position=0)]
        [string]
        $ProjectId,

        [Parameter(Mandatory)]
        [string]
        $DeployKeyId,

        [Parameter()]
        [string]
        $SiteUrl,

        [Parameter()]
        [switch]
        $Force
    ) 

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $GitlabAPIParams = @{
        Method = 'DELETE'
        Path   = "projects/$($Project.Id)/deploy_keys/$DeployKeyId"
    }

    # https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-shouldprocess?view=powershell-7.5#implementing--force
    if ($Force -and -not $PSBoundParameters.ContainsKey('Confirm')) {
        $ConfirmPreference = 'None'
    }

    if($PSCmdlet.ShouldProcess("Remove deploy key for project '$($Project.PathWithNamespace)'","Remove-GitlabProjectDeployKey")) {
        Invoke-GitlabApi @GitlabAPIParams -Verbose:$VerbosePreference -WhatIf:$WhatIfPreference | Out-Null
    }
}

function Enable-GitlabProjectDeployKey {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='Low')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName,Position=0)]
        [string]
        $ProjectId,

        [Parameter(Mandatory)]
        [string]
        $DeployKeyId,

        [Parameter()]
        [string]
        $SiteUrl,

        [Parameter()]
        [switch]
        $Force
    ) 

    $Project = Get-GitlabProject -ProjectId $ProjectId

    $GitlabAPIParams = @{
        Method = 'POST'
        Path   = "projects/$($Project.Id)/deploy_keys/$DeployKeyId/enable"
    }

    # https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-shouldprocess?view=powershell-7.5#implementing--force
    if ($Force -and -not $PSBoundParameters.ContainsKey('Confirm')) {
        $ConfirmPreference = 'None'
    }

    if($PSCmdlet.ShouldProcess("Enable deploy key for project '$($Project.PathWithNamespace)'","Enable-GitlabProjectDeployKey")) {
        Invoke-GitlabApi @GitlabAPIParams -Verbose:$VerbosePreference -WhatIf:$WhatIfPreference | New-WrapperObject 'Gitlab.DeployKey'
    }
}