Import-Module Az.KeyVault

$vaults = Get-AzKeyVault
$expiring = @()

foreach ($vault in $vaults) {
    $secrets = Get-AzKeyVaultSecret -VaultName $vault.VaultName
    foreach ($secret in $secrets) {
        if ($secret.Attributes.Expires -lt (Get-Date).AddDays(30)) {
            $expiring += $secret
        }
    }
}

$expiring | Export-Csv "expiring_secrets.csv" -NoTypeInformation

#
# detects secrets that expire soon
#
#