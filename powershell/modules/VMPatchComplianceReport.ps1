Import-Module Az.Compute

$vms = Get-AzVM
$report = foreach ($vm in $vms) {
    $status = Get-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Status
    [PSCustomObject]@{
        VM = $vm.Name
        OS = $vm.StorageProfile.OsDisk.OsType
        PatchStatus = $status.Statuses[1].DisplayStatus
    }
}

$report | Export-Csv "vm_patch_report.csv" -NoTypeInformation

# check VM patch status