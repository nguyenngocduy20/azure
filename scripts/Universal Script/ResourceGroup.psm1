function CreateRG {
    Param (
        [String] $RGName,
        [String] $Location
    )
    $result = New-AzureRmResourceGroup -Name $RGName -Location $Location
    if ($result -eq $null) {
        Write-Output "Create Resource Group unsuccessfully"
    } else {
        Write-Output "Created Resource Group: $($RGName)"
    }
}

function RemoveRG {
    Param (
        [String] $RGName
    )
    $result = Remove-AzureRmResourceGroup -Name $RGName
    if ($result -eq $null) {
        Write-Output "Remove Resource Group unsuccessfully"
    } else {
        Write-Output "Removed Resource Group: $($RGName)"
    }
}

function CheckRG {
    Param (
        [String] $RGName
    )
    $check = Get-AzureRmResourceGroup -Name $RGName
    if ($check -eq $null) {
        return 0
    } else {
        return 1
    }
    
}
