targetScope = 'resourceGroup'

@minLength(3)
@maxLength(10)
param prefix string

@minValue(0)
@maxValue(254)
param vnet_number int

var ddos_plan_name = '${prefix}-ddos-plan'
var vnet_name = '${prefix}-vnet'
var vnet_address_space = '10.${vnet_number}.0.0/16'
var subnet_address_space = '10.${vnet_number}.0.0/24'
var gateway_subnet_address_space = '10.${vnet_number}.254.0/24'

resource ddos_plan 'Microsoft.Network/ddosProtectionPlans@2020-11-01' = {
  name: ddos_plan_name
  location: resourceGroup().location
}

resource vnet 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: vnet_name
  location: resourceGroup().location
  dependsOn: [
    ddos_plan
  ]
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnet_address_space
      ]
    }
    subnets: [
      {
        name: 'main'
        properties: {
          addressPrefix: subnet_address_space
        }
      }
      {
        name: 'ingress'
        properties: {
          addressPrefix: gateway_subnet_address_space
        }
      }
    ]
    ddosProtectionPlan: {
      id: ddos_plan.id
    }
    enableDdosProtection: true
  }
}

output main_subnet_id string = vnet.properties.subnets[0].id
output gateway_subnet_id string = vnet.properties.subnets[1].id
