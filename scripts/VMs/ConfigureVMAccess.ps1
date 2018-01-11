$RGName = 'BoD-LAB'
$VmName = 'Ubuntu1204'
$Location = 'centralus'

$ExtensionName = 'VMAccessForLinux'
$Publisher = 'Microsoft.OSTCExtensions'
$Version = '1.4'

$PublicConf = '{}'
$PrivateConf = '{
  "username": "bod",
  "password": "any_password"
}'

Set-AzureRmVMExtension -ResourceGroupName $RGName -VMName $VmName -Location $Location `
  -Name $ExtensionName -Publisher $Publisher -ExtensionType $ExtensionName `
  -TypeHandlerVersion $Version -Settingstring $PublicConf -ProtectedSettingString $PrivateConf
