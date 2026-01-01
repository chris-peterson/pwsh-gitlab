class TrueOrFalseAttribute : System.Management.Automation.ArgumentTransformationAttribute {
    [object] Transform([System.Management.Automation.EngineIntrinsics] $engineIntrinsics, $inputData) {
        if ($inputData -is [bool]) {
            return $inputData
        }
        if ($inputData -eq 'true') {
            return $true
        }
        if ($inputData -eq 'false') {
            return $false
        }
        throw [System.Management.Automation.ArgumentTransformationMetadataException]::new(
            "Cannot convert '$inputData' to boolean. Use 'true' or 'false'."
        )
    }
}

class GitlabDateAttribute : System.Management.Automation.ArgumentTransformationAttribute {
    [object] Transform([System.Management.Automation.EngineIntrinsics] $engineIntrinsics, $inputData) {
        if ([string]::IsNullOrEmpty($inputData)) {
            return $inputData
        }

        if ($inputData -is [datetime]) {
            return $inputData.ToString('yyyy-MM-dd')
        }

        if ($inputData -is [string]) {
            if ($inputData -match '^\d{4}-\d{2}-\d{2}$') {
                return $inputData
            }

            $parsedDate = [datetime]::MinValue
            if ([datetime]::TryParse($inputData, [ref]$parsedDate)) {
                return $parsedDate.ToString('yyyy-MM-dd')
            }
        }

        throw [System.Management.Automation.ArgumentTransformationMetadataException]::new(
            "Cannot convert '$inputData' to GitLab date format. Provide a DateTime or a parseable date string."
        )
    }
}

class AccessLevelAttribute : System.Management.Automation.ArgumentTransformationAttribute {
    [object] Transform([System.Management.Automation.EngineIntrinsics] $engineIntrinsics, $inputData) {
        $mapping = @{
            10 = 'guest'
            20 = 'reporter'
            30 = 'developer'
            40 = 'maintainer'
            50 = 'owner'
        }

        $validNames = @('guest', 'reporter', 'developer', 'maintainer', 'owner')

        if ($inputData -in $validNames) {
            return $inputData
        }

        $numericValue = 0
        if ([int]::TryParse($inputData, [ref]$numericValue) -and $mapping.ContainsKey($numericValue)) {
            return $mapping[$numericValue]
        }

        throw [System.Management.Automation.ArgumentTransformationMetadataException]::new(
            "Cannot convert '$inputData' to access level. Valid values: $($validNames -join ', ') (or numeric: $($mapping.Keys -join ', '))."
        )
    }
}
