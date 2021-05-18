targetScope = 'resourceGroup'

@minLength(3)
@maxLength(7)
param prefix string

@minValue(0)
@maxValue(254)
param vnet_number int

var vnet_name = '${prefix}-vnet'
var vnet_address_space = '10.${vnet_number}.0.0/16'
var subnet_address_space = '10.${vnet_number}.0.0/24'

resource vnet 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: vnet_name
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet_address_space
      ]
    }
    subnets: [
      {
        name: 'main'
        properties: {
          addressPrefix: subnet_address_space
        }
      }
    ]
  }
}

output subnet_id string = vnet.properties.subnets[0].id
