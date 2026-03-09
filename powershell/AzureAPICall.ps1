$token = (Get-AzAccessToken).Token
$headers = @{ Authorization = "Bearer $token" }
Invoke-RestMethod -Uri "https://management.azure.com/subscriptions?api-version=2020-01-01" -Headers $headers