$vms = Get-AzVM | Where-Object {
    $_.Tags["Autostop"] -eq "true"
}

foreach ($vm in $vms) {
    $status = (Get-AzVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Status).Statuses[1].DisplayStatus
    if ($status -eq "VM running") {
        Stop-AzVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Force
    }
}