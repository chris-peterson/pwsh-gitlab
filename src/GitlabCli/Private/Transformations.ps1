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
