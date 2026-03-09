Get-AzRoleAssignment |
    Select-Object DisplayName, RoleDefinitionName, Scope |
    Export-Csv rbac_assignments.csv -NoTypeInformation