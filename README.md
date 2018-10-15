This is a Proof of Concept for using the Azure Key Vault service to manage a secret. 

**Requirements**

* Privileged Azure Account(I am using the free developer account)
* Azure Client CLI(I installed via HomeBrew)
* Node/NPM Installed(I am at v9.11.1/5.6.0 respectively)
* Bash shell(I am on OSX)
* jq installed for parsing json in bash shell(via homebrew)

Edit the env.json file to reflect the naming of the attributes and the secret you would like to store
```
{
    "group": "AzureResourceGroup", 
    "vault": "AzureKeyVault",
    "provider": "AzureKeyProvider",
    "secretKey": "MNEMONIC",
    "secretValue": "0X.This.Is.My.Secret"
}
```

Run the setup.sh script to deploy the ResourceGroup, Provider, KeyVault, and Secret to your Azure instance

``` $ ./setup.sh ```

Run the Example App that will refer to the deployed objects to retrieve the secret value

```$ node app.js```




