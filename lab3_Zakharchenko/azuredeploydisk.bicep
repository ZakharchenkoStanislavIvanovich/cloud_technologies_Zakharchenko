param diskName string = 'az104-disk5'

resource disk 'Microsoft.Compute/disks@2022-07-02' = {
  name: diskName
  location: 'East US'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: 32
  }
}
