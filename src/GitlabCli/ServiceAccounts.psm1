function Get-GitlabServiceAccount {
    [CmdletBinding(DefaultParameterSetName='Instance')]
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
        MaxPages   = Resolve-GitlabMaxPages -MaxPages:$MaxPages -All:$All
    }
    if ($PSCmdlet.ParameterSetName -eq 'Group') {
        # https://docs.gitlab.com/api/service_accounts/#list-all-group-service-accounts
        $Request.Path = "groups/$GroupId/service_accounts"
    } else {
        # https://docs.gitlab.com/api/service_accounts/#list-all-instance-service-accounts
        $Request.Path = "service_accounts"
    }

    $ServiceAccounts = Invoke-GitlabApi @Request | New-WrapperObject 'Gitlab.ServiceAccount'

    if ($ServiceAccountId) {
        # workaround for https://gitlab.com/gitlab-org/gitlab/-/issues/570317
        $ServiceAccount = $ServiceAccounts | Where-Object { $_.Id -eq $ServiceAccountId }
        if (-not $ServiceAccount) {
            throw "Service account with ID '$ServiceAccountId' not found."
        }
        $ServiceAccount
    } else {
        $ServiceAccounts
    }
}

function Update-GitlabServiceAccount {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName='Instance')]
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

    if ($PSCmdlet.ShouldProcess($ServiceAccountId, "update service account ($($Request | ConvertTo-Json))")) {
        Invoke-GitlabApi @Request | New-WrapperObject 'Gitlab.ServiceAccount'
    }
}

function Remove-GitlabServiceAccount {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High', DefaultParameterSetName='Instance')]
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

    if ($PSCmdlet.ShouldProcess("service account $ServiceAccountId", "$($Request | ConvertTo-Json)")) {
        Invoke-GitlabApi @Request | Out-Null
        Write-Host "Deleted service account '$ServiceAccountId'"
    }
}

function New-GitlabServiceAccount {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName='Instance')]
    param(
        [Parameter(ParameterSetName='Instance')]
        [Parameter(ParameterSetName='Group')]
        [string]
        $Name,

        [Parameter(ParameterSetName='Instance')]
        [Parameter(ParameterSetName='Group')]
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

    if ($PSCmdlet.ShouldProcess($Target, "Create ($($Request | ConvertTo-Json))")) {
        Invoke-GitlabApi @Request | New-WrapperObject 'Gitlab.ServiceAccount'
    }
}
