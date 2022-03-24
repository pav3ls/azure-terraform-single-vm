# Create Network and single VM using terraform on Azure


## Getting started

## Terraform authenticating using a Azure Service Principal with a Client Secret
```
az login
az account list
az account set --subscription="SUBSCRIPTION_ID"
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID"
```

## Configuring the Service Principal in Terraform

appId is the client_id defined above.
password is the client_secret defined above.
tenant is the tenant_id defined above.

```
export ARM_CLIENT_ID=""
export ARM_TENANT_ID=""
export ARM_SUBSCRIPTION_ID=""
export ARM_CLIENT_SECRET=""
```
