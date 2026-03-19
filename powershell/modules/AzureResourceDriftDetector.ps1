param(
    [Parameter(Mandatory)]
    [string]$SubscriptionId,

    [Parameter(Mandatory)]
    [string]$ExpectedConfigPath
)

Import-Module Az.Resources

$expected = Get-Content $ExpectedConfigPath | ConvertFrom-Json
Set-AzContext -Subscription $SubscriptionId

$actual = Get-AzResource | Select-Object Name, ResourceType, Location, Tags

$drift = Compare-Object -ReferenceObject $expected -DifferenceObject $actual -Property Name, ResourceType, Location

$timestamp = (Get-Date).ToString("yyyy-MM-dd_HH-mm_ss")
$drift | Export-Csv "drift_report_$timestamp.csv" -NoTypeInformation