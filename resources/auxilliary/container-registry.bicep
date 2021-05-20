targetScope = 'resourceGroup'

@minLength(3)
@maxLength(10)
param prefix string

var container_registry_name = '${prefix}registry'

resource registry 'Microsoft.ContainerRegistry/registries@2020-11-01-preview' = {
  name: container_registry_name
  location: resourceGroup().location
  sku: {
    name: 'Premium'
  }
  properties: {
    zoneRedundancy: 'Enabled'
  }
}
