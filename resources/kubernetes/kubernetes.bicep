targetScope = 'resourceGroup'

@minLength(3)
@maxLength(10)
param prefix string
param subnet_id string
param log_analytics_workspace_id string
param app_gateway_id string

var cluster_name = '${prefix}-aks-cluster'

resource aks 'Microsoft.ContainerService/managedClusters@2021-03-01' = {
  name: cluster_name
  location: resourceGroup().location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: prefix
    enableRBAC: true
    nodeResourceGroup: '${cluster_name}-resources'
    kubernetesVersion: '1.20.5'
    aadProfile: {
      managed: true
      tenantID: '72f988bf-86f1-41af-91ab-2d7cd011db47'
      adminGroupObjectIDs: [
        '10c171d7-c823-4f07-9052-e542fe0397a3'
      ]
    }
    agentPoolProfiles: [
      {
        name: 'main'
        availabilityZones: [
          '1'
          '2'
        ]
        count: 3
        enableAutoScaling: true
        maxCount: 10
        minCount: 3
        mode: 'System'
        vmSize: 'standard_ds2_v2'
        type: 'VirtualMachineScaleSets'
        vnetSubnetID: subnet_id
      }
    ]
    networkProfile: {
      serviceCidr: '192.168.0.0/16'
      dnsServiceIP: '192.168.0.5'
      loadBalancerSku: 'standard'
      networkPlugin: 'azure'
      networkPolicy: 'calico'
    }
    addonProfiles: {
      'azurepolicy': {
        enabled: true
      }
      'omsagent': {
        enabled: true
        config: {
          logAnalyticsWorkspaceResourceID: log_analytics_workspace_id
        }
      }
      'ingressApplicationGateway': {
        enabled: true
        config: {
          applicationGatewayId: app_gateway_id
        }
      }
    }
  }
}

output kubelet_principal_id string = aks.properties.identityProfile.kubeletIdentity.objectId
