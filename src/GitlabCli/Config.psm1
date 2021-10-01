function Set-DefaultGitlabCliSystem {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Name
    )

    $configuration = Get-GitlabCliConfig
    if($configuration.FromEnvironment) {
        Write-Warning "Unsupported: Current configuration is from environment variables."
        Write-Warning "Unset `$env:GITLAB_ACCESS_TOKEN and `$env:GITLAB_URL"
        return $configuration
    }

    if($configuration[$Name] -ne $null ) {
        $configuration.DefaultSite = $Name
        return Write-GitlabCliConfig $configuration
    }

    Write-Warning "System with $($Name) doesn't exist"
    return $configuration
}

function Add-GitlabCliSystem {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $Name,
        [Parameter(Mandatory=$true)]
        [string]
        $Token
    )
        
    $configuration = Get-GitlabCliConfig

    if($configuration.FromEnvironment) {
        Write-Warning "Unsupported: Current configuration is from environment variables."
        Write-Warning "Unset `$env:GITLAB_ACCESS_TOKEN and `$env:GITLAB_URL"
        return $configuration
    }

    if($configuration[$Name] -ne $null) {
        if($configuration[$Name].ApiToken -ne $Token) {
            Write-Host "A token already exists for $Name"
            $response = $(Read-Host -Prompt "Would you like to replace it? [y/n]")
            if($response -imatch "y") {
                $configuration[$Name].ApiToken = $Token
                Write-GitlabCliConfig $configuration
            } else {
                Write-Host "Information already exists"
                return $configuration
            }
        }
    }

    $configuration[$Name] = @{
        ApiToken = $Token
    }

    return Write-GitlabCliConfig $configuration
}

function Remove-GitlabCliSystem {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $Name
    )

    $configuration = Get-GitlabCliConfig
    if($configuration.FromEnvironment) {
        Write-Warning "Unsupported: Current configuration is from environment variables."
        Write-Warning "Unset `$env:GITLAB_ACCESS_TOKEN and `$env:GITLAB_URL"
        return
    }

    if($configuration[$Name] -eq $null) {
        Write-Warning "No entry for $($Name)"
    }

    $configuration.Remove($Name)
    return Write-GitlabCliConfig $configuration
}

function Write-GitlabCliConfig {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [hashtable]
        $configuration
    )

    Get-GitlabCliConfig | Out-Null
    
    Clear-Content $Global:GitlabCliConfigPath
    $configuration | ConvertTo-Json | Add-Content $Global:GitlabCliConfigPath
    return $configuration
}

function Get-GitlabCliConfig {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $ConfigRoot = "$($env:HOME)/.gitlabcli",
        
        [Parameter()]
        [string]
        $ConfigName = "config.json"
    )

    if($env:GITLAB_URL -ne $null -and $env:GITLAB_ACCESS_TOKEN -ne $null) {
        return @{
            "DefaultSite"=$env:GITLAB_URL
            "$($env:GITLAB_URL)" = @{
                ApiToken = $env:GITLAB_ACCESS_TOKEN
            }

            FromEnvironment=$true
        }
    }

    $configPath = "$($ConfigRoot)/$($ConfigName)"
    $Global:GitlabCliConfigPath = $configPath

    if(-NOT (Test-Path $configPath)) {
        if(-NOT(Test-Path $ConfigRoot)) {
            mkdir $ConfigRoot
        }
        Add-Content $configPath "{`"DefaultSite`": `"`" }" -Force        
    }

    return Get-Content $configPath | ConvertFrom-Json -AsHashtable
}