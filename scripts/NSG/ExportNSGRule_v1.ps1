$nsgList = Get-AzureRmNetworkSecurityGroup

foreach ($nsg in $nsgList) {
    $name = $nsg.name
    $path = $name + ".csv"
    $ofs = ","
    $Rule = Get-AzureRmNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg | Select Direction, Priority, Name, Protocol, [string]SourceAddressPrefix, SourcePortRange, DestinationAddressPrefix, DestinationPortRange, Access
    $Rule.SourceAddressPrefix
}
