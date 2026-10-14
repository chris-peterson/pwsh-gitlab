function Get-GitlabServiceAccount {
    [CmdletBinding(DefaultParameterSetName='Instance')]
    [OutputType('Gitlab.ServiceAccount')]
    param(
        [Parameter(Position=0, ParameterSetName='Instance')]
        [Parameter(Position=0, ParameterSetName='Group')]
        [int]
        [Alias('Id')]
        $ServiceAccountId,

        [Parameter(ParameterSetName='Group', Mandatory)]
        [string]
        $GroupId,

        [Parameter()]
        [string]
        $Username,

        [Parameter()]
        [string]
        $SiteUrl,

        [Parameter()]
        [uint]
        $MaxPages,

        [switch]
        [Parameter()]
        $All
    )

    $Request = @{
        HttpMethod = 'GET'
        Path       = ''
        # the API has no username filter, so a lookup by username reads every page
        MaxPages   = Resolve-GitlabMaxPages -MaxPages:$MaxPages -All:($All -or $Username)
    }
    if ($PSCmdlet.ParameterSetName -eq 'Group') {
        # https://docs.gitlab.com/api/service_accounts/#list-all-group-service-accounts
        $Request.Path = "groups/$GroupId/service_accounts"
    } else {
        # https://docs.gitlab.com/api/service_accounts/#list-all-instance-service-accounts
        $Request.Path = "service_accounts"
    }

    $ServiceAccounts = Invoke-GitlabApi @Request | New-GitlabObject 'Gitlab.ServiceAccount'
    if ($GroupId) {
        $ServiceAccounts | Add-Member -NotePropertyMembers @{
            GroupId = $GroupId
        }
    }

    if ($ServiceAccountId) {
        # workaround for https://gitlab.com/gitlab-org/gitlab/-/issues/570317
        $ServiceAccount = $ServiceAccounts | Where-Object { $_.Id -eq $ServiceAccountId }
        if (-not $ServiceAccount) {
            throw "Service account with ID '$ServiceAccountId' not found."
        }
        $ServiceAccount
    } elseif ($Username) {
        $ServiceAccount = $ServiceAccounts | Where-Object { $_.Username -eq $Username }
        if (-not $ServiceAccount) {
            Write-Error -Message "Service account '$Username' not found." -Category ObjectNotFound -TargetObject $Username
        }
        $ServiceAccount
    } else {
        $ServiceAccounts
    }
}

function Set-GitlabServiceAccount {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.ServiceAccount')]
    param(
        [Parameter(Mandatory)]
        [string]
        $GroupId,

        [Parameter(Mandatory)]
        [ServiceAccountUsername()]
        [string]
        $Username,

        [Parameter()]
        [string]
        $Name,

        [Parameter()]
        [string]
        $Email,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Existing = Get-GitlabServiceAccount -GroupId $GroupId -Username $Username -ErrorAction SilentlyContinue

    if (-not $Existing) {
        $ServiceAccount = New-GitlabServiceAccount -GroupId $GroupId -Username $Username -Name $Name -Email $Email
    } elseif (($Name -and $Name -ne $Existing.Name) -or ($Email -and $Email -ne $Existing.Email)) {
        $Update = @{
            GroupId          = $GroupId
            ServiceAccountId = $Existing.Id
        }
        if ($Name -and $Name -ne $Existing.Name) {
            $Update.Name = $Name
        }
        if ($Email -and $Email -ne $Existing.Email) {
            $Update.Email = $Email
        }
        $ServiceAccount = Update-GitlabServiceAccount @Update
    } else {
        Write-Verbose "Service account '$Username' already matches"
        return $Existing
    }

    if ($ServiceAccount) {
        $ServiceAccount | Add-Member -PassThru -NotePropertyMembers @{
            GroupId = $GroupId
        }
    }
}

function Update-GitlabServiceAccount {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName='Instance')]
    [OutputType('Gitlab.ServiceAccount')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int]
        [Alias('Id')]
        $ServiceAccountId,

        [Parameter(ParameterSetName='Group', Mandatory)]
        [string]
        $GroupId,

        [Parameter()]
        [string]
        $Name,

        [Parameter()]
        [string]
        $Username,

        [Parameter()]
        [string]
        $Email,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Request = @{
        HttpMethod = 'PATCH'
        # https://docs.gitlab.com/api/service_accounts/#update-an-instance-service-account
        Path    = 'service_accounts'
        Body    = @{}
    }
    if ($PSCmdlet.ParameterSetName -eq 'Group') {
        # https://docs.gitlab.com/api/service_accounts/#update-a-group-service-account
        $Request.Path = "groups/$GroupId/service_accounts"
    }
    $Request.Path += "/$ServiceAccountId"

    if ($Name) {
        $Request.Body.name = $Name
    }
    if ($Username) {
        $Request.Body.username = $Username
    }
    if ($Email) {
        $Request.Body.email = $Email
    }

    if ($PSCmdlet.ShouldProcess($ServiceAccountId, "update service account ($($Request | ConvertTo-GitlabLogText))")) {
        Invoke-GitlabApi @Request | New-GitlabObject 'Gitlab.ServiceAccount'
    }
}

function Remove-GitlabServiceAccount {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High', DefaultParameterSetName='Instance')]
    [OutputType([void])]
    param(
        [Parameter(Position=0, Mandatory, ParameterSetName='Instance', ValueFromPipelineByPropertyName)]
        [Parameter(Position=0, Mandatory, ParameterSetName='Group', ValueFromPipelineByPropertyName)]
        [int]
        [Alias('Id')]
        $ServiceAccountId,

        [Parameter(ParameterSetName='Group', Mandatory)]
        [string]
        $GroupId,

        [Parameter()]
        [string]
        $SiteUrl,

        [Parameter()]
        [switch]
        $Force
    )

    # https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-shouldprocess?view=powershell-7.5#implementing--force
    if ($Force -and -not $PSBoundParameters.ContainsKey('Confirm')) {
        $ConfirmPreference = 'None'
    }

    $Request = @{
        HttpMethod = 'DELETE'
        Path       = 'service_accounts'
    }
    if ($PSCmdlet.ParameterSetName -eq 'Group') {
        # https://docs.gitlab.com/api/service_accounts/#delete-a-group-service-account
        $Request.Path = "groups/$GroupId/service_accounts"
    }
    else {
        throw "Can't delete a non-group service account (https://gitlab.com/gitlab-org/gitlab/-/issues/570317); consider using 'Remove-GitlabUser -Id $ServiceAccountId'"
    }
    $Request.Path += "/$ServiceAccountId"

    if ($PSCmdlet.ShouldProcess("service account $ServiceAccountId", "$($Request | ConvertTo-GitlabLogText)")) {
        Invoke-GitlabApi @Request | Out-Null
        Write-Host "Deleted service account '$ServiceAccountId'"
    }
}

function New-GitlabServiceAccountPersonalAccessToken {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('Gitlab.NewPersonalAccessToken')]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string]
        $GroupId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [int]
        $ServiceAccountId,

        [Parameter(Mandatory)]
        [string]
        $Name,

        [Parameter(Mandatory)]
        [ValidateSet('api', 'read_user', 'read_api', 'read_repository', 'write_repository', 'read_registry', 'write_registry', 'create_runner', 'manage_runner', 'ai_features', 'k8s_proxy', 'self_rotate')]
        [string[]]
        $Scope,

        [Parameter()]
        [string]
        $Description,

        [Parameter()]
        [GitlabDate()][string]
        $ExpiresAt,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $GroupId = Resolve-GitlabGroupId $GroupId

    $Request = @{
        # https://docs.gitlab.com/api/service_accounts/#create-a-personal-access-token-for-a-group-service-account
        HttpMethod = 'POST'
        Path       = "groups/$GroupId/service_accounts/$ServiceAccountId/personal_access_tokens"
        Body       = @{
            name   = $Name
            scopes = $Scope
        }
    }
    if ($Description) {
        $Request.Body.description = $Description
    }
    if ($ExpiresAt) {
        $Request.Body.expires_at = $ExpiresAt
    }

    if ($PSCmdlet.ShouldProcess("service account $ServiceAccountId", "create personal access token '$Name'")) {
        Invoke-GitlabApi @Request | New-GitlabObject 'Gitlab.NewPersonalAccessToken'
    }
}

function Remove-GitlabServiceAccountPersonalAccessToken {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    [OutputType([void])]
    [Alias('Revoke-GitlabServiceAccountPersonalAccessToken')]
    param(
        [Parameter(Mandatory)]
        [string]
        $GroupId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('UserId')]
        [int]
        $ServiceAccountId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [int]
        $TokenId,

        [Parameter()]
        [string]
        $SiteUrl,

        [Parameter()]
        [switch]
        $Force
    )

    # https://learn.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-shouldprocess?view=powershell-7.5#implementing--force
    if ($Force -and -not $PSBoundParameters.ContainsKey('Confirm')) {
        $ConfirmPreference = 'None'
    }

    $GroupId = Resolve-GitlabGroupId $GroupId

    $Request = @{
        # https://docs.gitlab.com/api/service_accounts/#revoke-a-personal-access-token-for-a-group-service-account
        HttpMethod = 'DELETE'
        Path       = "groups/$GroupId/service_accounts/$ServiceAccountId/personal_access_tokens/$TokenId"
    }

    if ($PSCmdlet.ShouldProcess("service account $ServiceAccountId", "revoke personal access token $TokenId")) {
        Invoke-GitlabApi @Request | Out-Null
    }
}

function New-GitlabServiceAccount {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName='Instance')]
    [OutputType('Gitlab.ServiceAccount')]
    param(
        [Parameter(ParameterSetName='Instance')]
        [Parameter(ParameterSetName='Group')]
        [string]
        $Name,

        [Parameter(ParameterSetName='Instance')]
        [Parameter(ParameterSetName='Group')]
        [ServiceAccountUsername()]
        [string]
        $Username,

        [Parameter(ParameterSetName='Instance')]
        [Parameter(ParameterSetName='Group')]
        [string]
        $Email,

        [Parameter(ParameterSetName='Group', Mandatory)]
        [string]
        $GroupId,

        [Parameter()]
        [string]
        $SiteUrl
    )

    $Target = 'instance service accounts'
    $Request = @{
        # https://docs.gitlab.com/api/service_accounts.html#create-a-service-account
        HttpMethod = 'POST'
        Path       = 'service_accounts'
        Body       = @{}
    }
    if ($Name) {
        $Request.Body.name = $Name
    }
    if ($Username) {
        $Request.Body.username = $Username
    }
    if ($Email) {
        $Request.Body.email = $Email
    }

    if ($PSCmdlet.ParameterSetName -eq 'Group') {
        $Group = Get-GitlabGroup -GroupId $GroupId
        if (-not $Group.IsTopLevel) {
            throw "Service accounts can only be created in top-level groups; '$($Group.FullPath)' is a subgroup of '$($Group.ParentId)')."
        }
        $Request.Path = "groups/$($Group.Id)/service_accounts"
        $Target = "group '$($Group.FullPath)'"
    }

    if ($PSCmdlet.ShouldProcess($Target, "Create ($($Request | ConvertTo-GitlabLogText))")) {
        Invoke-GitlabApi @Request | New-GitlabObject 'Gitlab.ServiceAccount'
    }
}
