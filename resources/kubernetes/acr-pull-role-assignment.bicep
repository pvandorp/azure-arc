targetScope = 'resourceGroup'

@minLength(3)
@maxLength(10)
param prefix string
param container_registry_name string
param kubelet_principal_id string

resource registry 'Microsoft.ContainerRegistry/registries@2020-11-01-preview' existing = {
  name: container_registry_name
}

resource role_assignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: '${guid(prefix, kubelet_principal_id)}'
  scope: registry
  dependsOn: [
    registry
  ]
  properties: {
    principalId: kubelet_principal_id
    roleDefinitionId: '7f951dda-4ed3-4680-a7ca-43fe172d538d'
  }
}
