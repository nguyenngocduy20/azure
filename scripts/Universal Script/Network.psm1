function CreateNSG {
    Param (
        [String] $NSGName,
        [String] $Location,
        [String] $ResourceGroup
    )
    $rule1 = New-AzureRmNetworkSecurityRuleConfig -Name rdp-rule -Description "Allow RDP" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 `
    -SourceAddressPrefix Internet -SourcePortRange * `
    -DestinationAddressPrefix * -DestinationPortRange 3389

    $rule2 = New-AzureRmNetworkSecurityRuleConfig -Name ssh-rule -Description "Allow SSH" `
    -Access Allow -Protocol Tcp -Direction Inbound -Priority 101 `
    -SourceAddressPrefix Internet -SourcePortRange * `
    -DestinationAddressPrefix * -DestinationPortRange 22

    $nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $ResourceGroup -Location $Location `
    -Name $NSGName -SecurityRules $rule1,$rule2

    return $nsg
}

function RemoveNSG {
    Param (
        [String] $NSGName,
        [String] $ResourceGroup
    )

    Remove-AzureRmNetworkSecurityGroup -Name $NSGName -ResourceGroupName $ResourceGroup
}

function CreateVNET {
    Param (
        [String] $ResourceGroup,
        [String] $Location
    )

    $VNETName = Read-Host -Prompt "Enter VNET Name"
    $vnet = Get-AzureRMVirtualNetwork -Name $VNETName -ResourceGroupName $ResourceGroup
    if (-not ($vnet -eq $null)) {
        Write-Output "`tVNET $($VNETName) has already existed"
    } else {
        # create VNET
        Write-Output "`tVNET $($VNETName) does not exist. Create new VNET"
        $VNETAddressPrefix = Read-Host -Prompt "`tEnter VNET Address Prefix (e.g: 10.1.0.0/16)"
        $DefaultSubnetName = Read-Host -Prompt "`tEnter default subnet name"
        $SubnetAddressPrefix = Read-Host -Prompt "`tEnter default subnet address suffix (e.g: 10.1.0.0/24)"
        # $vnet = CreateVNET -ResourceGroup $ResourceGroup -Location $Location -VNETName $VNETName `
        -VNETAddressPrefix $VNETAddressPrefix -DefaultSubnetName $DefaultSubnetName `
        -SubnetAddressPrefix $SubnetAddressPrefix
        if ($DefaultSubnetName -eq $null) {
            $DefaultSubnetName = "default"
        }

        if ($VNETAddressPrefix -eq $null) {
            $VNETAddressPrefix = "10.1.0.0/16"
        }

        if ($SubnetAddressPrefix -eq $null) {
            $SubnetAddressPrefix = "10.1.0.0/24"
        }

        # Create a subnet configuration
        $subnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name $DefaultSubnetName -AddressPrefix $SubnetAddressPrefix

        # Create a virtual network
        $vnet = New-AzureRmVirtualNetwork -ResourceGroupName $ResourceGroup -Location $Location `
        -Name $VNETName -AddressPrefix $VNETAddressPrefix -Subnet $subnetConfig
    }
    
    return $vnet
}

function CreatePublicIP {
    Param (
        [String] $ResourceGroup,
        [String] $Location,
        [String] $PIPName,
        [String] $AllocationMethod
    )

    $pip = New-AzureRmPublicIpAddress -ResourceGroupName $ResourceGroup -Location $Location `
    -Name $PIPName -AllocationMethod $AllocationMethod

    return $pip
}

function CreateNIC {
    Param (
        [String] $ResourceGroup,
        [String] $Location,
        [String] $Name,
        [String] $VNETName,
        [String] $SubnetName,
        [String] $PublicIP,
        [String] $NetworkSecurityGroup
    )

    $VNET = Get-AzureRMVirtualNetwork -Name $VNETName -ResourceGroupName $ResourceGroup
    $subnet = Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $SubnetName
    $pip = Get-AzureRmPublicIpAddress -Name $PublicIP -ResourceGroupName $ResourceGroup
    $nsg = Get-AzureRmNetworkSecurityGroup -Name $NetworkSecurityGroup -ResourceGroupName $ResourceGroup

    $nic = New-AzureRmNetworkInterface -Name $Name -ResourceGroupName $ResourceGroup -Location $Location `
    -SubnetId $subnet.Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id

    return $nic
}
