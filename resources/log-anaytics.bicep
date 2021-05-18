targetScope = 'resourceGroup'

@minLength(3)
@maxLength(10)
param prefix string

var workspace_name = '${prefix}-workspace'

resource workspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
  name: workspace_name
  location: resourceGroup().location
  properties: {
    sku: {
      name: 'Standard'
    }
  }
}

output workspace_id string = workspace.id
