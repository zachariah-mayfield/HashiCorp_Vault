#!/bin/bash
# ~/GitHub/Main/HashiCorp_Vault/Scripts/Nuke_Everything_N_Rebuld.sh

INIT_FILE=~/"GitHub/Main/HashiCorp_Vault/vault/data/vault-init.json"

# Check if the VIRTUAL_ENV environment variable is not empty.
if [[ -n "$VIRTUAL_ENV" ]]; then
  echo "You are in a Python virtual environment: $VIRTUAL_ENV"
else
  echo "You are NOT in a Python virtual environment."
  echo "Please activate your Python virtual environment before running this script."
  echo "Run the following to activate your Python Virtual Environment: source ~/GitHub/Main/HashiCorp_Vault/.venv/bin/activate"
  exit 1
fi

# Remove Vault file that holds Keys and Token
echo "removing vault-init.json"
rm -f ~/"GitHub/Main/HashiCorp_Vault/vault/data/vault-init.json"
# Remove PostgreSQL config 
echo "removing init.sql"
rm -f ~/"GitHub/Main/HashiCorp_Vault/postgres/Config/init.sql"
# Remove vault config 
echo "removing vault-config.hcl"
rm -f ~/"GitHub/Main/HashiCorp_Vault/vault/config/vault-config.hcl"

# ~/"GitHub/Main/HashiCorp_Vault/vault/policies/secrets_engine_policy.hcl"

# This is the core command that stops and removes the containers and networks defined in your container and remove any named volumes and clean up "orphan" containers.
docker-compose down --volumes --remove-orphans

# Remove all Docker Containers, Volumes, Images, Networks, and build cache
docker system prune --all --volumes --force

# This tells Docker Compose to run the containers in the background (“detached mode”).
docker-compose up -d --build

# Wait for the containers to start
echo "Waiting for containers to start..."
wait_time=30 # seconds

# Get the logs from the Vault container
docker-compose logs -f vault_server

# # Extract the Vault root token from the initialization file.
# export ROOT_TOKEN=$(jq -r '.root_token' "$INIT_FILE")
# # Login with root token
# # VAULT_TOKEN="$ROOT_TOKEN" vault login "$ROOT_TOKEN" > /dev/null

# echo "Check ~/GitHub/Main/HashiCorp_Vault/vault/data/vault-init.json for the root token."
# # export VAULT_TOKEN=$(jq -r .root_token vault/data/vault-init.json)
# echo "The Root token is: ${ROOT_TOKEN}"
# echo "The Vault token is: ${VAULT_TOKEN}"
# source <(jq -r '.root_token | "export VAULT_TOKEN=" + .' vault/data/vault-init.json)
# vault token lookup
# # Enable the secrets engine
# vault secrets enable -path=secret -version=2 kv
# echo "The Vault is running and the secrets engine is enabled at path 'secret'."
# vault secrets list
# echo "You can use this token to access the Vault UI at http://localhost:8200."

# # Add a Secret
# # store some values under a vault path secret/myapp/config
# vault kv put secret/myapp/config username="admin" password="s3cr3t"

# # Read the Secret Back
# vault kv get secret/myapp/config

# # Use the Secret in a Script (CLI or API)
# vault kv get -format=json secret/myapp/config | jq -r '.data.data | "User: \(.username), Pass: \(.password)"'

# # Update a Secret:
# vault kv put secret/myapp/config username="admin" password="newpass"

# # Delete a Secret:
# vault kv delete secret/myapp/config

# # Store a Certificate and Private Key
# vault kv put secret/certificates/Lenovo-T480/SSH_user_login \
#     cert=@"$HOME/GitHub/Main/Lenovo-T480/X_Secret/zachariah.mayfield_Certificate.pem" \
#     key=@"$HOME/GitHub/Main/Lenovo-T480/X_Secret/zachariah.mayfield_Certificate.key"

# # Retrieve the Certificate and Private Key
# vault kv get -format=json secret/certificates/Lenovo-T480/SSH_user_login \
#     | jq -r '.data.data | "cert: \(.cert) key: \(.key)"'

# # Delete the Certificate and Private Key
# vault kv delete secret/certificates/Lenovo-T480/SSH_user_login