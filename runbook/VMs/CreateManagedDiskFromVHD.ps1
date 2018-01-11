#Provide the subscription Id where Managed Disks will be created
#$subscriptionId = '41dfad76-6849-458e-a2a0-bba3e1b6f6d2'

#Provide the name of your resource group where Managed Disks will be created. 
$resourceGroupName ='FIS-MCS-Demo-OMS'

#Provide the name of the Managed Disk
$diskName = 'Ubuntu12_04'

#Provide the size of the disks in GB. It should be greater than the VHD file size.
$diskSize = '30'

#Provide the storage type for Managed Disk. PremiumLRS or StandardLRS.
$storageType = 'StandardLRS'

#Provide the Azure region (e.g. westus) where Managed Disk will be located.
#This location should be same as the storage account where VHD file is stored
#Get all the Azure location using command below:
#Get-AzureRmLocation
$location = 'southeastasia'

#Provide the URI of the VHD file (page blob) in a storage account. Please not that this is NOT the SAS URI of the storage container where VHD file is stored. 
#e.g. https://contosostorageaccount1.blob.core.windows.net/vhds/contosovhd123.vhd
#Note: VHD file can be deleted as soon as Managed Disk is created.
$sourceVHDURI = 'https://globalsa.blob.core.windows.net/vhds/Ubuntu12_04_LTS.vhd'

#Provide the resource Id of the storage account where VHD file is stored.
#e.g. /subscriptions/6472s1g8-h217-446b-b509-314e17e1efb0/resourceGroups/MDDemo/providers/Microsoft.Storage/storageAccounts/contosostorageaccount
#This is an optional parameter if you are creating managed disk in the same subscription
$storageAccountId = '/subscriptions/41dfad76-6849-458e-a2a0-bba3e1b6f6d2/resourceGroups/FIS-MCS-Demo-OMS/providers/Microsoft.Storage/storageAccounts/globalsa'

#Set the context to the subscription Id where Managed Disk will be created
#Select-AzureRmSubscription -SubscriptionId $SubscriptionId

$diskConfig = New-AzureRmDiskConfig -AccountType $storageType -Location $location -CreateOption Import -StorageAccountId $storageAccountId -SourceUri $sourceVHDURI -OSType Linux -DiskSizeGB 30
 
New-AzureRmDisk -Disk $diskConfig -ResourceGroupName $resourceGroupName -DiskName $diskName
