param([string]$Keyword = "Error")

Get-WinEvent -LogName Application |
    Where-Object { $_.Message -match $Keyword } |
    Select-Object TimeCreated, Id, LevelDisplayName, Message |
    ConvertTo-Json | Out-File "c:\homedir\eventlog_results.json"