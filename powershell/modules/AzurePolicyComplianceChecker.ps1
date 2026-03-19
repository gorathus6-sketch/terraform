Import-Module Az.PolicyInsights

$nonCompliant = Get-AzPolicyState -ComplianceState nonCompliant

$nonCompliant = |
    Select-Object ResourceId, PolicyAssignmentName, ComplianceState |
    Export-Csv "policy_noncompliant.csv" -NoTypeInformation

# this script lists non-compliant Azure resources