targetScope = 'subscription'

@minLength(3)
@maxLength(10)
param prefix string = 'padorp'

resource kubernetes_group 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: prefix
  location: 'westeurope'
}

resource aux_group 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: '${prefix}-auxilliary'
  location: 'westeurope'
}

module initiatives 'policies/policy_initiative.bicep' = {
  name: '${prefix}-policy-initiatives-deployment'
  dependsOn: [
    aux_group
    kubernetes_group
  ]
  params: {
    prefix: prefix
  }
}

module aux_policy_assignments 'policies/aux_policy.bicep' = {
  name: 'auxilliary-policy-assignments'
  dependsOn: [
    initiatives
  ]
  scope: resourceGroup(aux_group.name)
  params: {
    prefix: prefix
    policy_definition_id: initiatives.outputs.aux_initiative_id
  }
}

module kubernetes_policy_assignments 'policies/kubernetes_policy.bicep' = {
  name: 'kubernetes-policy-assignments'
  dependsOn: [
    initiatives
  ]
  scope: resourceGroup(kubernetes_group.name)
  params: {
    prefix: prefix
    policy_definition_id: initiatives.outputs.kubernetes_initiative_id
  }
}

module container_registry 'auxilliary/container-registry.bicep' = {
  name: 'container-registry-deployment'
  scope: resourceGroup(aux_group.name)
  dependsOn: [
    aux_group
  ]
  params: {
    prefix: prefix
  }
}

module log_anaytics 'auxilliary/log-anaytics.bicep' = {
  name: 'log-analytics-workspace-deployment'
  scope: resourceGroup(aux_group.name)
  dependsOn: [
    aux_group
  ]
  params: {
    prefix: prefix
  }
}

module network 'auxilliary/vnet.bicep' = {
  name: 'network-deployment'
  dependsOn: [
    aux_group
  ]
  scope: resourceGroup(aux_group.name)
  params: {
    prefix: prefix
    vnet_number: 0
  }
}

module gateway 'auxilliary/gateway.bicep' = {
  name: 'app-gateway-deployment'
  scope: resourceGroup(aux_group.name)
  dependsOn: [
    network
  ]
  params: {
    prefix: prefix
    gateway_subnet_id: network.outputs.gateway_subnet_id
  }
}

module aks 'kubernetes/kubernetes.bicep' = {
  name: 'aks-deployment'
  scope: resourceGroup(kubernetes_group.name)
  dependsOn: [
    gateway
    log_anaytics
    kubernetes_group
  ]
  params: {
    prefix: prefix
    subnet_id: network.outputs.main_subnet_id
    app_gateway_id: gateway.outputs.app_gateway_id
    log_analytics_workspace_id: log_anaytics.outputs.workspace_id
  }
}

resource registry 'Microsoft.ContainerRegistry/registries@2020-11-01-preview' existing = {
  name: '${prefix}registry'
  scope: resourceGroup(aux_group.name)
}

module acr_pull_access 'kubernetes/acr-pull-role-assignment.bicep' = {
  name: 'acr-pull-role-assignment'
  dependsOn: [
    container_registry
    aks
  ]
  scope: resourceGroup(aux_group.name)
  params: {
    prefix: prefix
    container_registry_name: container_registry.outputs.name
    kubelet_principal_id: aks.outputs.kubelet_principal_id
  }
}
