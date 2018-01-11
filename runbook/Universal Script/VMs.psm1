function CreateVMFromScratch {
    Param (
        [String] $ResourceGroup = $(throw "Parameter Missing: -ResourceGroup ResourceGroupName"),
        [String] $VMName,
        [String] $ManagedDisk,
        [String] $UnmanagedDisk,
        [String] $DiskSize,
        [String] $BootDiagnostic,
        [String] $OS,
        [String] $VMSize,
        [String] $Location,
        [String] $StorageAccount,
        [PSCredential] $Credential
    )

    # Create VNET
    $vnet = CreateVNET -ResourceGroup $ResourceGroup -Location $Location
    # Choose subnet
    $vnet = Get-AzureRMVirtualNetwork -Name $VNETName -ResourceGroupName $ResourceGroup
    $subnet = Get-AzureRmVirtualNetworkSubnetConfig -VirtualNetwork $vnet
    $SubnetName = $subnet.Name
    if ($subnet.length -eq 1) {
        Write-Output "Choose default subnet $($SubnetName)"
    } else {
        Write-Output "`tChoose a subnet: "
        for ($i = 0; $i -lt $SubnetName.length; $i++) {
            Write-Output "`t`t$($i + 1). $($SubnetName[$i])"
        }
        do {
            $choice = Read-Host -Prompt "Enter a number"
        } until (($choice -gt 0) -and ($choice -le $SubnetName.length))
        $subnet = $subnet[$choice - 1]
    }

    # check if NetworkSecurityGroup exist
    $NSGName = Read-Host -Prompt "`tEnter Network Security Group name"
    $nsg = Get-AzureRmNetworkSecurityGroup -Name $NetworkSecurityGroup -ResourceGroupName $ResourceGroup
    if (-not ($nsg -eq $null)) {
        Write-Output "`tNetwork Security Group $($NetworkSecurityGroup) has already existed"
    } else {
        # create NetworkSecurityGroup
        Write-Output "`tNetwork Security Group $($NSGName) does not exist. Create new NSG"
        $nsg = CreateNSG -ResourceGroup $ResourceGroup -Location $Location -NSGName $NSGName
    }

    # check isPublic
    $isPublic = Read-Host -Prompt "`tVM use Public IP? (n: no (default), y: yes)"
    if (-not ($isPublic -like "y")) {
        Write-Output "`tVM does not use Public IP"
    } else {
        $PIPName = Read-Host -Prompt "`tEnter Public IP name"
        $pip = Get-AzureRmPublicIpAddress -Name $PIPName -ResourceGroupName $ResourceGroup
        if (-not ($pip -eq $null)) {
            Write-Output "Public IP $($PIPName) has already existed"
        } else {
            Write-Output "`tPublic IP $($PIPName) does not exist. Create new Public IP"
            $AllocationMethod = Read-Host -Prompt "`tPublic IP allocate <static> or <dynamic> (default)"
            if ($AllocationMethod -like "static") {
                $pip = CreatePIP -ResourceGroup $ResourceGroup -Location $Location -PIPName $PIPName `
                -AllocationMethod $AllocationMethod
            } else {
                $pip = CreatePIP -ResourceGroup $ResourceGroup -Location $Location -PIPName $PIPName `
                -AllocationMethod $AllocationMethod
            }
        }
    }

    # check if NIC existed
    $NICName = Read-Host -Prompt "`tEnter NIC Name"
    $nic = Get-AzureRmNetworkInterface -Name $NICName -ResourceGroupName $ResourceGroup
    if (-not($nic -eq $null)) {
        Write-Output "`tNIC $($NICName) has already existed"
    } else {
        Write-Output "`tNIC $($NICName) does not exist. Create new NIC"
        $nic = CreateNIC -ResourceGroup $ResourceGroup -Location $Location -Name $NICName `
        -VNETName $VNETName -SubnetName $subnet.Name -PublicIP $pip.Name -NetworkSecurityGroup $nsg.Name
    }

    
}
