<#
$srcUri = "https://bodlabdiag191.blob.core.windows.net/vhds/Ubuntu12_04_LTS.vhd"

$Context = New-AzureStorageContext -StorageAccountName "fisxlabdiag120" -StorageAccountKey "HWzgyT3YRykcYKw2Zd3Zg+sYdPprZ+6R31hNnne0MbIxsiHvlm3cEMzgZNIh7fpglv9WPLp9U4AAZUWY5rhIXg=="
Start-AzureStorageBlobCopy -AbsoluteUri $srcUri -DestContainer "vhds" -DestBlob "Ubuntu1204" -DestContext $Context
#>

$srcUri = "https://your_blob.blob.core.windows.net/vhds/Ubuntu12_04_LTS.vhd" 
 
### Target Storage Account (East US) ###
$storageAccount = "storage_name"
$storageKey = ""your_storage_key=="
 
### Create the destination context for authenticating the copy
$destContext = New-AzureStorageContext  –StorageAccountName $storageAccount `
                                        -StorageAccountKey $storageKey  
 
### Target Container Name
$containerName = "vhds"
 
### Create the target container in storage
#New-AzureStorageContainer -Name $containerName -Context $destContext 
 
### Start the Asynchronous Copy ###
$blob1 = Start-AzureStorageBlobCopy -srcUri $srcUri `
                                    -DestContainer $containerName `
                                    -DestBlob "Ubuntu1204.vhd" `
                                    -DestContext $destContext

$status = $blob1 | Get-AzureStorageBlobCopyState

### Loop until complete ###                                    
While($status.Status -eq "Pending"){
  $status = $blob1 | Get-AzureStorageBlobCopyState 
  Start-Sleep 10
  ### Print out status ###
  $status
}
