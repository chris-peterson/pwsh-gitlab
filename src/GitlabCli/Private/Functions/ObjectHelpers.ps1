# Object wrapper helper functions

function global:Add-CoalescedProperty {
    param (
        [PSCustomObject]
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $On,

        [string]
        [Parameter(Mandatory=$true)]
        $To,

        [string[]]
        [Parameter(Mandatory=$true)]
        $From
    )

    Process {
        if ($On.PSObject.Properties.Name -contains $To) {
            return # don't overwrite existing property
        }
        foreach ($PropertyName in $From) {
            if ($null -ne $On.$PropertyName) {
                $On | Add-Member -MemberType NoteProperty -Name $To -Value $On.$PropertyName
                return # use first non-null value
            }
        }
    }
}

function global:Get-GitlabDefaultSortProperty {
    param (
        [Parameter(Mandatory, Position=0)]
        $Object
    )

    # a type that defines a SortKey picks its own ordering; everything else
    # falls back to the first of these it has, most recent first
    $RecencyPropertyNames = @('UpdatedAt', 'LastActivityAt')

    $PropertyNames = $Object.PSObject.Properties.Name

    if ($PropertyNames -contains 'SortKey') {
        return @{ Property = 'SortKey'; Descending = $false }
    }

    foreach ($Candidate in $RecencyPropertyNames) {
        if ($PropertyNames -contains $Candidate) {
            return @{ Property = $Candidate; Descending = $true }
        }
    }
}

function global:Test-GitlabSortPreference {
    # a caller that was given -Sort or -OrderBy is passing the user's ordering
    # through to the API; leave that result in the order it came back
    $CallStack = Get-PSCallStack
    for ($i = 1; $i -lt $CallStack.Count; $i++) {
        $BoundParameters = $CallStack[$i].InvocationInfo.BoundParameters
        if (-not $BoundParameters) {
            continue
        }
        foreach ($Name in 'Sort', 'OrderBy') {
            $Value = $null
            if ($BoundParameters.TryGetValue($Name, [ref] $Value) -and -not [string]::IsNullOrWhiteSpace($Value)) {
                Write-Verbose "Sort: $Name was passed to [$($CallStack[$i].InvocationInfo.MyCommand.Name)], skipping default sort"
                return $true
            }
        }
    }
    $false
}

function global:New-GitlabObject {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Creates PSCustomObject wrappers, not a state-changing operation')]
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline)]
        $InputObject,

        [Parameter(Position=0)]
        [string]
        $DisplayType,

        [Parameter()]
        [switch]
        $PreserveCasing
    )
    Begin {
        $Wrappers = New-Object 'Collections.Generic.List[object]'
    }
    Process {
        foreach ($item in $InputObject) {
            if ($item -is [hashtable]) {
                $item = [PSCustomObject]$item
            }

            $Wrapper = New-Object PSObject
            $item.PSObject.Properties |
                Sort-Object Name |
                ForEach-Object {
                    $Name = if ($PreserveCasing) { $_.Name } else { $_.Name | ConvertTo-PascalCase }
                    $Value = $_.Value

                    if ($Value -is [string] -and $Value -match '^\d{4}-\d{2}-\d{2}$') {
                        $Value = [datetime]::Parse($Value)
                    }

                    $Wrapper | Add-Member -MemberType NoteProperty -Name $Name -Value $Value

                    if ($Value -is [datetime]) {
                        $SortableName = "${Name}Sortable"
                        $SortableValue = $Value.ToString('yyyy-MM-dd HH:mm')
                        $Wrapper | Add-Member -MemberType NoteProperty -Name $SortableName -Value $SortableValue
                    }
                }

            # aliases for common property names
            $Wrapper | Add-CoalescedProperty -From @('WebUrl', 'TargetUrl') -To 'Url'

            if ($DisplayType) {
                $Wrapper.PSTypeNames.Insert(0, $DisplayType)

                $IdentityPropertyName = $global:GitlabIdentityPropertyNameExemptions[$DisplayType]
                if ($IdentityPropertyName -eq $null) {
                    $IdentityPropertyName = 'Iid' # default for anything that isn't explicitly mapped
                }
                if ($IdentityPropertyName -ne '') {
                    if ($Wrapper.$IdentityPropertyName) {
                        $TypeShortName = $DisplayType.Split('.') | Select-Object -Last 1
                        $Wrapper | Add-CoalescedProperty -From $IdentityPropertyName -To "$($TypeShortName)Id"
                    } else {
                        Write-Warning "$DisplayType does not have an identity field"
                    }
                }
            }

            if ($DisplayType -eq 'Gitlab.MergeRequest') {
                # ForgeCli's contract names the open state `open`, as GitHub does.
                if ($Wrapper.State -eq 'opened') {
                    $Wrapper.State = 'open'
                }
                # Id is the iid shown in the UI, as on GitHub; the instance-wide id stays as DatabaseId.
                if ($null -ne $Wrapper.Iid) {
                    $Wrapper | Add-Member -MemberType NoteProperty -Name 'DatabaseId' -Value $Wrapper.Id -Force
                    $Wrapper | Add-Member -MemberType NoteProperty -Name 'Id' -Value $Wrapper.Iid -Force
                }
            }
            $Wrappers.Add($Wrapper)
        }
    }
    End {
        if ($Wrappers.Count -lt 2 -or (Test-GitlabSortPreference)) {
            Write-Output $Wrappers
            return
        }

        $Sort = Get-GitlabDefaultSortProperty $Wrappers[0]
        if ($Sort) {
            $Wrappers | Sort-Object -Property $Sort.Property -Descending:$Sort.Descending
        } else {
            Write-Output $Wrappers
        }
    }
}
