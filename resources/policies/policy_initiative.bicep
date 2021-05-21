targetScope = 'subscription'

@minLength(3)
@maxLength(10)
param prefix string

var kubernetes_initiative_name = '${prefix}-kubernetes-initiative'
var aux_initiative_name = '${prefix}-auxilliary-initiative'

resource kubernetes_initiative 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: '${guid(kubernetes_initiative_name)}'
  properties: {
    description: 'The global initiative for all policies that should be enforced on Kubernetes clusters.'
    displayName: '(${prefix}) Global Kubernetes Policies'
    policyType: 'Custom'
    policyDefinitions: [
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/0a15ec92-a229-4763-bb14-0ea34a568f8d'
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/1d61c4d2-aef2-432b-87fc-7f96b019b7e1'
        parameters: {
          configurationResourceName: {
            value: 'infra-configuration'
          }
          operatorInstanceName: {
            value: 'infra-configuration'
          }
          operatorNamespace: {
            value: 'configurations'
          }
          operatorScope: {
            value: 'cluster'
          }
          operatorParams: {
            value: '--branch=main --path=releases/demo --git-poll-interval=3s --sync-garbage-collection --git-user=padorp --git-email=padorp@microsoft.com'
          }
          repositoryUrl: {
            value: 'https://github.com/pvandorp/azure-arc.git'
          }
          enableHelmOperator: {
            value: 'true'
          }
          chartValues: {
            value: '--set helm.versions=v3'
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/8dfab9c4-fe7b-49ad-85e4-1e9be085358f'
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/523b5cd1-3e23-492f-a539-13118b6d1e3a'
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/ac4a19c2-fa67-49b4-8ae5-0b2e78c49457'
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/95edb821-ddaf-4404-9732-666045e056b4'
        parameters: {
          excludedNamespaces: {
            value: [
              'kube-system'
              'gatekeeper-system'
              'azure-arc'
              'configurations'
            ]
          }
        }
      }
    ]
  }
}

resource aux_initiative 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: '${guid(aux_initiative_name)}'
  properties: {
    description: 'The global initiative for all policies for services auxilliary to Kubernetes.'
    displayName: '(${prefix}) Global Auxilliary Services Policies'
    policyType: 'Custom'
    policyDefinitions: [
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/c25d9a16-bc35-4e15-a7e5-9db606bf9ed4'
      }
    ]
  }
}

output kubernetes_initiative_id string = kubernetes_initiative.id
output aux_initiative_id string = aux_initiative.id
