Param (
    [string] $filePath,
    [string] $container
)
$storageAccountName = "your_storage_name"
$storageAccountKey = "your_storage_key=="
$storageContext = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey

# $containerName = $container
$containerName = "vhd"
# $file = $filePath
$file = "D:\Azure\Blob\UploadFile.ps1"
New-AzureStorageContainer -Name $containerName -Permission Off -Context $storageContext
Set-AzureStorageBlobContent -Container $containerName -File $file -Context $storageContext
Get-AzureStorageBlob -Context $storageContext -Container $containerName
