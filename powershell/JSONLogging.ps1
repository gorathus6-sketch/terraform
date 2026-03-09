$log = [PSCustomObject]@{
    Timestamp = (Get-Date)
    Message   = "Service check complete"
}
$log | ConvertTo-Json | Add-Content log.json