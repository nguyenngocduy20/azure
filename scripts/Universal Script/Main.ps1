Import-Module .\VMs.psm1
Import-Module .\Network.psm1
Import-Module .\ResourceGroup.psm1

Write-Output "UNIVERSAL SCRIPT TO MANAGE AZURE"
Write-Output "  _    _ _   _ _______      ________ _____            _         _____  _____ _____  _____ _____ _______ "
Write-Output " | |  | | \ | |_   _\ \    / /  ____|  __ \     /\   | |       / ____|/ ____|  __ \|_   _|  __ \__   __|"
Write-Output " | |  | |  \| | | |  \ \  / /| |__  | |__) |   /  \  | |      | (___ | |    | |__) | | | | |__) | | |   "
Write-Output " | |  | | . `` | | |   \ \/ / |  __| |  _  /   / /\ \ | |       \___ \| |    |  _  /  | | |  ___/  | |   "
Write-Output " | |__| | |\  |_| |_   \  /  | |____| | \ \  / ____ \| |____   ____) | |____| | \ \ _| |_| |      | |   "
Write-Output "  \____/|_| \_|_____|   \/   |______|_|  \_\/_/    \_\______| |_____/ \_____|_|  \_\_____|_|      |_|   "
Write-Output "                                                                                                        "
Write-Output "@eldwyn: nguyenngoc.duy20@gmail.com                                                                     "

$stop = 0

while ($stop -eq 0) {
    Write-Output "`nPlease select your action:"
    Write-Output "`t1. Login to Azure"
    Write-Output "`t2. Virtual Machines"
    Write-Output "`t3. Storage Account"
    Write-Output "`t4. Resource Group"
    Write-Output "`t0. Exit"
    Write-Output ""
    do {
        $choice = Read-Host -Prompt "Enter your choice [0-4]"
        if ($choice -lt 0 -or $choice -gt 4) {
            Write-Output "Invalid Choice"
        }
    } until ($choice -ge 0 -and $choice -le 4)

    if ($choice -eq 0) { ### exit
        $stop = 0
        Write-Output "Thank you!"
        exit
    }

    if ($choice -eq 1) { ### Login to Azure
        try {
            $check = Get-AzureRMContext
            if (-not($check.Environment -like "*Azure*")) {
                $result = Login-AzureRmAccount
                if ($result -eq $null) {
                    Write-Host "Authentication Unsuccessful"
                }
            } else {
                Write-Output "`nYour account's already logged in"
            }
        } catch {}
    }

    if ($choice -eq 2) { ### Virtual Machine
        Write-Output "`nVirtual Machine actions: "
        Write-Output "`t1. Create Azure VM from scratch"
        Write-Output "`t2. Create Azure VM from specialized VHD"
        Write-Output "`t3. Create Azure VM from existing managed disk"
        Write-Output "`t4. Create Azure VM from snapshot"
        Write-Output "`t0. Back"
        do {
            $choiceVM = Read-Host -Prompt "Enter your choice [0-4]"
            if ($choice -lt 0 -or $choice -gt 4) {
                Write-Output "Invalid Choice"
            }
        } until ($choiceVM -ge 0 -and $choiceVM -le 4)

        if ($choiceVM -eq 0) {
            $stop = 0
        }
        
        if ($choiceVM -eq 1) {
            
        }

        if ($choiceVM -eq 2) {
        }

        if ($choiceVM -eq 3) {
        }

        if ($choiceVM -eq 4) {
        }
    }

    if ($choice -eq 3) { ### Storage Account
    }

    if ($choice -eq 4) { ### Resource Group
        Write-Output "`nResource Group actions: "
        Write-Output "`t1. Create Resource Group"
        Write-Output "`t2. Remove Resource Group"
        Write-Output "`t0. Back"
        do {
            $choiceRG = Read-Host -Prompt "Enter your choice [0-2]"
            if ($choiceRG -lt 0 -or $choiceRG -gt 2) {
                Write-Output "Invalid Choice"
            }
        } until ($choiceRG -ge 0 -and $choiceRG -le 2)

        if ($choiceRG -eq 0) {
            $stop = 0
        }

        if ($choiceRG -eq 1) { ### Create Resource Group
            $RGName = Read-Host -Prompt "Enter Resource Group name"
            $Location = Read-Host -Prompt "Enter location"

            CreateRG -RGName $RGName -Location $Location
        }

        if ($choiceRG -eq 2) { ### Remove Resource Group
            do {
                $RGName = Read-Host -Prompt "Enter Resource Group name"
                $check = CheckRG -RGName $RGName
                if ($check -eq 0) {
                    Write-Output "Resource Group does NOT exist"
                }
            } until ($check -eq 1)
            RemoveRG -RGName $RGName
        }
    }
}
