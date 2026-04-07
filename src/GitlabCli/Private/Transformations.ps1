if (-not ([System.Management.Automation.PSTypeName]'TrueOrFalseAttribute').Type) {
    Add-Type @'
using System;
using System.Management.Automation;

public class TrueOrFalseAttribute : ArgumentTransformationAttribute
{
    public override object Transform(EngineIntrinsics engineIntrinsics, object inputData)
    {
        if (inputData is bool) return inputData;
        string str = inputData?.ToString();
        if (string.Equals(str, "true", StringComparison.OrdinalIgnoreCase)) return true;
        if (string.Equals(str, "false", StringComparison.OrdinalIgnoreCase)) return false;
        throw new ArgumentTransformationMetadataException(
            string.Format("Cannot convert '{0}' to boolean. Use 'true' or 'false'.", inputData));
    }
}

public class GitlabDateAttribute : ArgumentTransformationAttribute
{
    public override object Transform(EngineIntrinsics engineIntrinsics, object inputData)
    {
        if (inputData == null) return inputData;
        string str = inputData.ToString();
        if (string.IsNullOrEmpty(str)) return inputData;
        if (inputData is DateTime dt) return dt.ToString("yyyy-MM-dd");
        if (System.Text.RegularExpressions.Regex.IsMatch(str, @"^\d{4}-\d{2}-\d{2}$")) return str;
        DateTime parsed;
        if (DateTime.TryParse(str, out parsed)) return parsed.ToString("yyyy-MM-dd");
        throw new ArgumentTransformationMetadataException(
            string.Format("Cannot convert '{0}' to GitLab date format. Provide a DateTime or a parseable date string.", inputData));
    }
}

public class AccessLevelAttribute : ArgumentTransformationAttribute
{
    private static readonly System.Collections.Generic.Dictionary<int, string> Mapping =
        new System.Collections.Generic.Dictionary<int, string>
        {
            { 10, "guest" },
            { 20, "reporter" },
            { 30, "developer" },
            { 40, "maintainer" },
            { 50, "owner" }
        };

    private static readonly string[] ValidNames = { "guest", "reporter", "developer", "maintainer", "owner" };

    public override object Transform(EngineIntrinsics engineIntrinsics, object inputData)
    {
        string str = inputData?.ToString();
        foreach (var name in ValidNames)
        {
            if (string.Equals(str, name, StringComparison.OrdinalIgnoreCase)) return name;
        }
        int numericValue;
        if (int.TryParse(str, out numericValue) && Mapping.ContainsKey(numericValue))
        {
            return Mapping[numericValue];
        }
        throw new ArgumentTransformationMetadataException(
            string.Format("Cannot convert '{0}' to access level. Valid values: guest, reporter, developer, maintainer, owner (or numeric: 10, 20, 30, 40, 50).", inputData));
    }
}
'@
}
