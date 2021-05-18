targetScope = 'resourceGroup'

@minLength(3)
@maxLength(10)
param prefix string

param gateway_subnet_id string


var public_ip_name = '${prefix}-gateway-pip'
var app_gateway_name = '${prefix}-gateway'
var app_gateway_id = resourceId('Microsoft.Network/applicationGateways', app_gateway_name)

resource public_ip 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: public_ip_name
  location: resourceGroup().location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
    '2'
  ]
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: 'mixellaneous'
    }
  }
}

resource app_gateway 'Microsoft.Network/applicationGateways@2020-11-01' = {
  name: app_gateway_name
  location: resourceGroup().location
  dependsOn: [
    public_ip
  ]
  zones: [
    '1'
    '2'
  ]
  properties: {
    autoscaleConfiguration: {
      minCapacity: 2
      maxCapacity: 4
    }
    sku: {
      name: 'Standard_v2'
      tier: 'Standard_v2'
    }
    gatewayIPConfigurations: [
      {
        name: 'default'
        properties: {
          subnet: {
            id: gateway_subnet_id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'default'
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'default'
        properties: {
          port: 80
          protocol: 'Http'
        }
      }
    ]
    httpListeners: [
      {
        name: 'default'
        properties: {
          frontendIPConfiguration: {
            id: '${app_gateway_id}/frontendIPConfigurations/default'
          }
          frontendPort: {
            id: '${app_gateway_id}/frontendPorts/web'
          }
          protocol: 'Http'
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'default'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: '${app_gateway_id}/httpListeners/default'
          }
          backendAddressPool: {
            id: '${app_gateway_id}/backendAddressPools/default'
          }
          backendHttpSettings: {
            id: '${app_gateway_id}/backendHttpSettingsCollection/default'
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'web'
        properties: {
          port: 80
        }
      }
      {
        name: 'ssl'
        properties: {
          port: 443
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'default'
        properties: {
          publicIPAddress: {
            id: public_ip.id
          }
        }
      }
    ]
  }
}

output app_gateway_id string = app_gateway.id
