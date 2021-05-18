targetScope = 'resourceGroup'

@minLength(3)
@maxLength(10)
param prefix string

param subnet_id string

var cluster_name = '${prefix}-cluster'
var cluster_identity = '${prefix}-mi'

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: cluster_identity
  location: resourceGroup().location
}

resource aks 'Microsoft.ContainerService/managedClusters@2021-03-01' = {
  name: cluster_name
  location: resourceGroup().location
  dependsOn: [
    identity
  ]
  sku: {
    name: 'Basic'
  }
  properties: {
    dnsPrefix: prefix
    enableRBAC: true
    nodeResourceGroup: '${cluster_name}-resources'
    kubernetesVersion: '1.20.5'
    identityProfile: identity
    aadProfile: {
      managed: true
      tenantID: '336b498d-d4da-4216-b76f-21fe7f4affd5'
      adminGroupObjectIDs: [
        '0ea7997e-15e6-4e50-87f1-fd3a38d9235a'
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
        osType:'Linux'
        osSKU: 'Ubuntu'
        osDiskType: 'Ephemeral'
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
  }
}
