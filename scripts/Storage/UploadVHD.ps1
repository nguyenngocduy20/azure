# Login-AzureRmAccount

$rgName = "Demo"
$urlOfUploadedImageVhd = "https://globalsa.blob.core.windows.net/vhds/Ubuntu12_04_LTS.vhd"
Add-AzureRmVhd -ResourceGroupName $rgName -Destination $urlOfUploadedImageVhd -LocalFilePath "E:\Ubuntu 12.04 VHD\ubuntu 12 04.vhd"
