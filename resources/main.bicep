targetScope = 'subscription'

@minLength(3)
@maxLength(7)
param prefix string

resource group 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: 'azure-arc'
  location: 'westeurope'
}

module network 'vnet.bicep' = {
  name: 'network-deployment'
  dependsOn: [
    group
  ]
  scope: resourceGroup(group.name)
  params: {
    prefix: prefix
    vnet_number: 0
  }
}

module aks 'kubernetes.bicep' = {
  name: 'aks-deployment'
  scope: resourceGroup(group.name)
  dependsOn: [
    network
  ]
  params: {
    prefix: prefix
    subnet_id: network.outputs.subnet_id
  }
}
