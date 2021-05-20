# azure-arc
This is my Azure Arc demo repository. It will contain Bicep files creating and maintaining the infrastructure needed for the demos and it will contain YAML file used by the Azure Arc GitOps implementation.

## Status
[![Infrastructure-as-Code](https://github.com/pvandorp/azure-arc/actions/workflows/infrastructure.yml/badge.svg)](https://github.com/pvandorp/azure-arc/actions/workflows/infrastructure.yml)

Azure Policy Add-on
- Install and Enable: /providers/Microsoft.Authorization/policyDefinitions/0a15ec92-a229-4763-bb14-0ea34a568f8d
- Deploy: /providers/Microsoft.Authorization/policyDefinitions/a8eff44f-8c92-45c3-a3fb-9880802d67a7
GitOps configuration using no secrets
- No Secrets: /providers/Microsoft.Authorization/policyDefinitions/1d61c4d2-aef2-432b-87fc-7f96b019b7e1
Azure Defender
- AKS: /providers/Microsoft.Authorization/policyDefinitions/523b5cd1-3e23-492f-a539-13118b6d1e3a
- Arc: /providers/Microsoft.Authorization/policyDefinitions/8dfab9c4-fe7b-49ad-85e4-1e9be085358f
- ACR: /providers/Microsoft.Authorization/policyDefinitions/c25d9a16-bc35-4e15-a7e5-9db606bf9ed4
Role-Based Access Control (RBAC)
- /providers/Microsoft.Authorization/policyDefinitions/ac4a19c2-fa67-49b4-8ae5-0b2e78c49457
privileged containers
- /providers/Microsoft.Authorization/policyDefinitions/95edb821-ddaf-4404-9732-666045e056b4