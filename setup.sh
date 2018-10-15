FIND_GROUP="$(jq -r '.group' env.json)"
export GROUP="${FIND_GROUP}"

FIND_VAULT="$(jq -r '.vault' env.json)"
export VAULT="${FIND_VAULT}"

FIND_PROVIDER="$(jq -r '.provider' env.json)"
export PROVIDER="${FIND_PROVIDER}"

FIND_SECRET_KEY="$(jq -r '.secretKey' env.json)"
export SECRET_KEY="${FIND_SECRET_KEY}"

FIND_SECRET_VALUE="$(jq -r '.secretValue' env.json)"
export SECRET_VALUE="${FIND_SECRET_VALUE}"

echo "Cleaning Up Previous Deployment"
az group delete --name $GROUP
rm ./group.json

az keyvault delete --name $VAULT
rm ./vault.json
rm ./secret.json

FIND_APP_ID_TO_DELETE="$(jq -r '.appId' provider.json)"
export APP_ID_TO_DELETE="${FIND_APP_ID_TO_DELETE}"
az ad sp delete --id  $APP_ID_TO_DELETE
rm ./provider.json

az provider unregister --namespace Microsoft.KeyVault

echo "Done Cleaning"

echo "Registering to use the KeyVault Service"
az provider register --namespace Microsoft.KeyVault

echo "Creating Resource Group:" $GROUP
az group create --name $GROUP --location "East US" > ./group.json

echo "Creating Vault:" $VAULT
az keyvault create --name $VAULT --resource-group $GROUP --location "East US" > ./vault.json

echo "Creating Secret: " $SECRET_KEY " with value: " $SECRET_VALUE
az keyvault secret set --vault-name $VAULT --name $SECRET_KEY --value $SECRET_VALUE > ./secret.json

echo "Creating App Provider: " $PROVIDER
az ad sp create-for-rbac -n $PROVIDER > ./provider.json

FIND_APP_ID="$(jq -r '.appId' provider.json)"
export APP_ID="${FIND_APP_ID}"
az keyvault set-policy --name $VAULT --spn $APP_ID --secret-permissions get

