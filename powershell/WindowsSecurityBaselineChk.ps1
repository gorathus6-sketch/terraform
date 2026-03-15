$checks = @(
    @{ Name="FirewallEnabled"; Path="HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile"; Key="EnableFirewall"; Expected="1" },
)

$results = foreach ($c in $checks) {
    $value = (Get-ItemProperty -Path $c.Path -Name $c.Key).$($c.Key)
    [pscustomobject]@{
        Setting  = $c.Name
        Expected = $c.Expected
        Actual   = $value
        Status   = if ($value -eq $c.Expected) {"OK"} else {"FAIL"}
    }
}

$results | Format-Table