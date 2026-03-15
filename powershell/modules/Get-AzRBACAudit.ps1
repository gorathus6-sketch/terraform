<#
.SYNOPSIS
    Audits Azure RBAC assignments for security and compliance.

.DESCRIPTION
    Collects all role assignments in a subscription or resource group,
    identifies high-privilege roles, wildcard scopes, and orphaned identities.
    Outputs structured JSON and logs operational steps.

.PARAMETER SubscriptionId
    Azure subscription ID to audit.

.PARAMETER ResourceGroup
    Optional. Limits audit to a specific resource group.

.PARAMETER OutputPath
    Path to write JSON output.

.PARAMETER LogPath
    Path to write log file.

.EXAMPLE
    .\Get-AzRBACAudit.ps1 -SubscriptionId "xxxx-xxxx" -OutputPath c:\homedir\rbac.json
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$SubscriptionId,

    [string]$ResourceGroup,

    [string]$OutputPath = "c:\homedir\rbac-audit.json",

    [string]$LogPath = "c:\homedir\rbac-audit.log"
)

#
# logging
#
function Write-Log {
    param([string]$Message)
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    "$timestamp  :: $Message" | Out-File -FilePath $LogPath -Append
}

Write-Log "Starting RBAC audit..."

#
# safe exec wrapper
#
function Invoke-Safe {
    param(
        [string]$Name,
        [scriptblock]$Block
    )

    try {
        Write-Log ("Running: {0}" -f $Name)
        & $Block
    }
    catch {
        Write-Log (ERROR in {0}: {1}" -f $Name, $_")
        return $null
    }
}

#
# Set Context
#
Invoke-Safe -Name "Set-AzContext" -Block {
    Set-AzContext -SubscriptionId $SubscriptionId | Out-Null
}
#
# resource group filter
# 
$scopeFilter = @{}
if ($ResourceGroup) {
    $scopeFilter["ResourceGroupName"] = $ResourceGroup
    Write-Log ("Filtering RBAC audit to resource group: {0}" -f $ResourceGroup)
}

#
# Collect Role Assignments
#
$assignments = Invoke-Safe -Name "Get-AzRoleAssignment" -Block {
    Get-AzRoleAssignment @scopeFilter
}

#
# identify high-privilege roles
#
$highPrivRoles = @(
    "Owner",
    "Contributor",
    "User Access Administrator"
)

$highPriv = $assignments | Where-Object {
    $highPrivRoles -contains $_.RoleDefinitionName
} | Select-Object DisplayName, SignInName, RoleDefinitionName, Scope, ObjectId

#
# identify orphaned identities
#
$orphans = foreach ($a in $assignments) {
    $obj = Invoke-Safe -Name "Get-AzADObject" -Block {
        Get-AzADObject -ObjectId $a.ObjectId
    }

    if (-not $obj) {
        [pscutomobject]@{
            DisplayName = $a.DisplayName
            ObjectId    = $a.ObjectId
            Role        = $a.RoleDefinitionName
            Scope       = $a.Scope
        }
    }
}

#
# identify wildcard scopes
#
$wildcards = $assignments | Where-Object {
    $_.Scope -match "/subscription/.+$" -or $_.Scope -match "/resourceGroups/.+$"
} | Select-Object DisplayName, RoleDefinitionName, Scope

#
# build output objects
#
$report = [ordered]@{
    Timestamp          = (Get-Date)
    Subscription       = $SubscriptionId
    ResourceGroup      = $ResourceGroup
    TotalAssignments   = $assignments.Count
    HighPrivelege      = $highPriv
    OrphanedIdentities = $orphans
    $WildcardScopes    = $wildcards
    $AllAssignments    = $assignments | Select-Object DisplayName, SignInName, RoleDefinitionName, Scope, ObjectId  
}

#
# write output
#
try {
    $report | ConvertTo-Json -Depth 8 | Out-File $OutputPath
    Write-Log ("RBAC audit written to {0}" -f $OutputPath)
}
catch {
    Write-Log ("ERROR writing output: {0}" -f $_)
    exit 2
}

Write-Log "RBAC audit completed with success."
exit 0