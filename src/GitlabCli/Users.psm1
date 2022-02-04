function Get-GitlabUser {
    param (
        [Parameter(ParameterSetName='ByUserId', Mandatory=$false)]
        [Alias("Username")]
        [string]
        $UserId,

        [Parameter(ParameterSetName='ByEmail', Mandatory=$false)]
        [string]
        $EmailAddress,

        [Parameter(ParameterSetName='ByMe', Mandatory=$False)]
        [switch]
        $Me,

        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    if ($UserId) {
        if (-not [uint]::TryParse($UserId, [ref] $null)) {
            $UserId = Invoke-GitlabApi GET "users" @{
                username = $UserId
            } | Select-Object -First 1 -ExpandProperty id
        }
        Invoke-GitlabApi GET "users/$UserId" -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.User'
    }
    if ($EmailAddress) {
        $UserId = Invoke-GitlabApi GET "search" @{
            scope = 'users'
            search = $EmailAddress
        } -SiteUrl $SiteUrl -WhatIf:$WhatIf | Select-Object -First 1 -ExpandProperty id
        Invoke-GitlabApi GET "users/$UserId" -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.User'
    }
    if ($Me) {
        Invoke-GitlabApi GET 'user' -SiteUrl $SiteUrl -WhatIf:$WhatIf | New-WrapperObject 'Gitlab.User'
    }
}

<#
.SYNOPSIS
Returns Gitlab User Events

.PARAMETER UserId
User Id either as an integer or Gitlab username

.PARAMETER EmailAddress
User email address

.PARAMETER Me
Get your events

.PARAMETER TargetType
Filters to specific Target Types of the Gitlab API @ https://docs.gitlab.com/ee/api/events.html#target-types

.PARAMETER Before
Return events before this data

.PARAMETER After
Return events after this data

.PARAMETER SiteUrl
Alternate Gitlab API url

.PARAMETER WhatIf
shows calls

.EXAMPLE
Get-GitlabUserEvent -Me

.NOTES
Date formatting is YYYY-MM-DD as defined at https://docs.gitlab.com/ee/api/events.html#date-formatting
#>
function Get-GitlabUserEvent {
    param (
        [Parameter(ParameterSetName='ByUserId', Mandatory=$false)]
        [Alias("Username")]
        [string]
        $UserId,

        [Parameter(ParameterSetName='ByEmail', Mandatory=$false)]
        [string]
        $EmailAddress,

        [Parameter(ParameterSetName='ByMe', Mandatory=$False)]
        [switch]
        $Me,

        [Parameter(Mandatory=$False)]
        [ValidateSet("approved","closed","commented","created","destroyed","expired","joined","left","merged","pushed","reopened","updated")]
        [string]
        $Action,

        [Parameter(Mandatory=$False)]
        [ValidateSet("issue","milestone","merge_request","note","project","snippet","user")]
        [string]
        $TargetType,

        [Parameter(Mandatory=$False)]
        [ValidateScript({ValidateGitlabDateFormat $_})]
        [string]
        $Before,

        [Parameter(Mandatory=$False)]
        [ValidateScript({ValidateGitlabDateFormat $_})]
        [string]
        $After,

        [Parameter(Mandatory=$False)]
        [ValidateSet("asc","desc")]
        [string]
        $Sort,

        [Parameter(Mandatory=$False)]
        [uint]
        $MaxPages = 1,

        [Parameter(Mandatory=$False)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    $getGitlabUserParameters = @{}
    
    if($PSCmdlet.ParameterSetName -eq "ByUserId" ) {
        $getGitlabUserParameters.UserId = $UserId
    } 
    
    if ($PSCmdLet.ParameterSetName -eq "ByEmail") {
        $getGitlabUserParameters.UserId = $EmailAddress
    }

    if($PSCmdlet.ParameterSetName -eq "ByMe") {
        $getGitlabUserParameters.Me=$true
    }

    $user = Get-GitlabUser @getGitlabUserParameters -WhatIf:$WhatIf -SiteUrl $SiteUrl

    $query = @{}
    if($Before) {
        $query.before = $Before
    }
    if($After) {
        $query.after = $After
    }

    if($Action) {
        $query.action = $Action
    }
    if($Sort) {
        $query.sort = $Sort
    }

    Invoke-GitlabApi GET "users/$($user.Id)/events" -Query $query -MaxPages $MaxPages -SiteUrl $SiteUrl -WhatIf:$WhatIf |
        New-WrapperObject 'Gitlab.Event'

}

function Get-GitlabCurrentUser {
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $SiteUrl,

        [switch]
        [Parameter(Mandatory=$false)]
        $WhatIf
    )

    Get-GitlabUser -Me -SiteUrl $SiteUrl -WhatIf:$WhatIf
}
