#!/bin/bash
# ~/GitHub/Main/HashiCorp_Vault/Scripts/create_vault_certificate_secret.sh

export VAULT_TOKEN=$(jq -r .root_token vault/data/vault-init.json)

echo echo "The Vault token is: ${VAULT_TOKEN}"

# Store a Certificate and Private Key in Vault - The "@" symbol is used to read the contents of the file.
vault kv put secret/certificates/Lenovo-T480/SSH_user_login \
    cert=@"$HOME/GitHub/Main/Lenovo-T480/X_Secret/zachariah.mayfield_Certificate.pem" \
    key=@"$HOME/GitHub/Main/Lenovo-T480/X_Secret/zachariah.mayfield_Certificate.key"

# Retrieve the Certificate and Private Key from Vault
vault kv get -format=json secret/certificates/Lenovo-T480/SSH_user_login \
    | jq -r '.data.data | "cert: \(.cert) key: \(.key)"'

# Delete the Certificate and Private Key from Vault
echo "To delete the certificate and private key, uncomment the following line in the script."
# vault kv delete secret/certificates/Lenovo-T480/SSH_user_login