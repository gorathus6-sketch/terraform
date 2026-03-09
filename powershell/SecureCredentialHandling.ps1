$cred = Get-Credential
Invoke-Command -ComputerName server -Credential $cred -ScriptBlock { hostname }