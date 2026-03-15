param(
    [string]$WorkspaceId,
    [string]$Query = "Heartbeat | take 10"
)

$result = Invoke-AzOperationalInsightsQuery `
    -WorkspaceId $WorkspaceId `
    -Query $Query

$result.Results | Format-Table