param([string]$Path = "C:\Windows")

(Get-Acl $Path).Access |
    Select-Object IdentityReference, FileSystemRights, AccessControlType |
    Export-Csv "c:\homedir\acl_export.csv" -NoTypeInformation