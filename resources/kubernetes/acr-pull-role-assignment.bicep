targetScope = 'resourceGroup'

@minLength(3)
@maxLength(10)
param prefix string
param kubelet_principal_id string

resource role_assignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: '${guid(prefix, kubelet_principal_id)}'
  properties: {
    principalId: kubelet_principal_id
    roleDefinitionId: '7f951dda-4ed3-4680-a7ca-43fe172d538d'
  }
}
