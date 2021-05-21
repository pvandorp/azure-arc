targetScope = 'resourceGroup'

@minLength(3)
@maxLength(10)
param prefix string

param policy_definition_id string

var policy_assignment_name = '${prefix}-auxilliary-services-policies'

resource assignment 'Microsoft.Authorization/policyAssignments@2020-09-01' = {
  name: policy_assignment_name
  location: resourceGroup().location
  properties: {
    displayName: '(${prefix}) Global Auxilliary Services Policies'
    policyDefinitionId: policy_definition_id
  }
}
