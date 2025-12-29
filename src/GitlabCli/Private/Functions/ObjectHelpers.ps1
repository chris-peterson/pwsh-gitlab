# Object wrapper helper functions

function Add-CoalescedProperty {
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

function New-GitlabObject {
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
    Begin{}
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
                    $Wrapper | Add-Member -MemberType NoteProperty -Name $Name -Value $_.Value
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
            Write-Output $Wrapper
        }
    }
    End{}
}
