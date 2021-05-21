targetScope = 'resourceGroup'

@minLength(3)
@maxLength(10)
param prefix string

param policy_definition_id string

var policy_assignment_name = '${prefix}-kubernetes-policies'

resource assignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: policy_assignment_name
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: '(${prefix}) Global Kubernetes Policies'
    policyDefinitionId: policy_definition_id
  }
}

resource role_assignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: '${guid(prefix, assignment.id)}'
  dependsOn: [
    assignment
  ]
  properties: {
    principalId: assignment.identity.principalId
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  }
}
