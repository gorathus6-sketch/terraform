param(
    [string]$WorkspaceId,
    [string]$Query
)

Import-Module Az.OperationalInsights

$result = Invoke-AzOperationalInsightsQuery -WorkspaceId $WorkspaceId -Query $Query
$result.Results | Export-Csv "kql_output.csv" -NoTypeInformation

#
# script for monitoring / intergrated runtime
# automation
# runs KQL queries and exports resultls
#