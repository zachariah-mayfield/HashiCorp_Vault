# Extract the Vault root token from the initialization file.
export ROOT_TOKEN=$(jq -r '.root_token' "$INIT_FILE")
# Login with root token
# VAULT_TOKEN="$ROOT_TOKEN" vault login "$ROOT_TOKEN" > /dev/null

echo "Check ~/GitHub/Main/HashiCorp_Vault/vault/data/vault-init.json for the root token."
# export VAULT_TOKEN=$(jq -r .root_token vault/data/vault-init.json)
echo "The Root token is: ${ROOT_TOKEN}"
echo "The Vault token is: ${VAULT_TOKEN}"
source <(jq -r '.root_token | "export VAULT_TOKEN=" + .' vault/data/vault-init.json)
vault token lookup
# Enable the secrets engine
vault secrets enable -path=secret -version=2 kv
echo "The Vault is running and the secrets engine is enabled at path 'secret'."
vault secrets list
echo "You can use this token to access the Vault UI at http://localhost:8200."

# Add a Secret
# store some values under a vault path secret/myapp/config
vault kv put secret/myapp/config username="admin" password="Enter-Your-Password-Here"

# Read the Secret Back
vault kv get secret/myapp/config

# Use the Secret in a Script (CLI or API)
vault kv get -format=json secret/myapp/config | jq -r '.data.data | "User: \(.username), Pass: \(.password)"'

# Update a Secret:
vault kv put secret/myapp/config username="admin" password="newpass"

# Delete a Secret:
vault kv delete secret/myapp/config

# Store a Certificate and Private Key
vault kv put secret/certificates/Lenovo-T480/SSH_user_login \
    cert=@"$HOME/GitHub/Main/Lenovo-T480/X_Secret/zachariah.mayfield_Certificate.pem" \
    key=@"$HOME/GitHub/Main/Lenovo-T480/X_Secret/zachariah.mayfield_Certificate.key"

# Retrieve the Certificate and Private Key
vault kv get -format=json secret/certificates/Lenovo-T480/SSH_user_login \
    | jq -r '.data.data | "cert: \(.cert) key: \(.key)"'

# Delete the Certificate and Private Key
vault kv delete secret/certificates/Lenovo-T480/SSH_user_login