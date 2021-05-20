#!/bin/bash
PREFIX=$1

if [ -z "$PREFIX" ]
then
    echo "A custom prefix was not supplied. The default prefix will be used."
    PREFIX="padorp"
fi

SP=( $(az ad sp create-for-RBAC --skip-assignment --name "https://${PREFIX}-onboarding" --query '[appId, password, tenant]' -o tsv) )

echo "appId: ${SP[0]}"
echo "password: ${SP[1]}"
echo "tenant: ${SP[2]}"

RG_ID=$(az group show -n $PREFIX --query 'id' -o tsv)

sleep 30

az role assignment create --role 34e09817-6cbe-4d01-b1a2-e0eac5743d41 --assignee ${SP[0]} --scope $RG_ID

az login --service-principal -u ${SP[0]} -p ${SP[1]} --tenant ${SP[2]}
az connectedk8s connect -n local-kind-cluster -g $PREFIX