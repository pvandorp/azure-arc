targetScope = 'subscription'

@minLength(3)
@maxLength(10)
param prefix string

resource group 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: 'azure-arc'
  location: 'westeurope'
}

module log_anaytics 'log-anaytics.bicep' = {
  name: 'log-analytics-workspace-deployment'
  scope: resourceGroup(group.name)
  dependsOn: [
    group
  ]
  params: {
    prefix: prefix
  }
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

module gateway 'gateway.bicep' = {
  name: 'app-gateway-deployment'
  scope: resourceGroup(group.name)
  dependsOn: [
    network
  ]
  params: {
    prefix: prefix
    gateway_subnet_id: network.outputs.gateway_subnet_id
  }
}

module aks 'kubernetes.bicep' = {
  name: 'aks-deployment'
  scope: resourceGroup(group.name)
  dependsOn: [
    gateway
    log_anaytics
  ]
  params: {
    prefix: prefix
    subnet_id: network.outputs.main_subnet_id
    app_gateway_id: gateway.outputs.app_gateway_id
    log_analytics_workspace_id: log_anaytics.outputs.workspace_id
  }
}
