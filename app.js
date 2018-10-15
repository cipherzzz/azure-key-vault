'use strict';

const fs = require('fs');
 
var msRestAzure = require('ms-rest-azure');
var KeyVault = require('azure-keyvault');
var AuthenticationContext = require('adal-node').AuthenticationContext;

let providerJSON = fs.readFileSync('provider.json');  
let provider = JSON.parse(providerJSON);  

let secretJSON = fs.readFileSync('secret.json');  
let secret = JSON.parse(secretJSON);

var clientId = provider.appId; // service principal
var domain = provider.tenant; // tenant id
var password = provider.password; 


var keyVaultClient;

msRestAzure.loginWithServicePrincipalSecret(clientId, password, domain, function (err, credentials) {
    if (err) return console.log(err);

    var kvCredentials = new KeyVault.KeyVaultCredentials(authenticator);
    keyVaultClient = new KeyVault.KeyVaultClient(kvCredentials);

    getSecret(secret.id);

});


function authenticator(challenge, callback) {
    // Create a new authentication context.
    var context = new AuthenticationContext(challenge.authorization);

    // Use the context to acquire an authentication token.
    return context.acquireTokenWithClientCredentials(challenge.resource, clientId, password, function (err, tokenResponse) {
        if (err) throw err;
        // Calculate the value to be set in the request's Authorization header and resume the call.
        var authorizationValue = tokenResponse.tokenType + ' ' + tokenResponse.accessToken;

        return callback(null, authorizationValue);
    });
}


function getSecret(vaultUri, callback) {
    console.log(`Getting the secret from:\n ${vaultUri}`);

    keyVaultClient.getSecret(vaultUri,
        (err, result) => {
            if (err) throw err;

            console.log("Secret: "+result.value)
        });
}

