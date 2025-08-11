#!/bin/bash
# ~/GitHub/Main/HashiCorp_Vault/Scripts/Start_HashiCorp_Vault_From_Scratch.sh

# Create the Certificates:
sh ~/GitHub/Main/HashiCorp_Vault/Certificate/make_certs.sh

# Check if the VIRTUAL_ENV environment variable is not empty.
if [[ -n "$VIRTUAL_ENV" ]]; then
  echo "You are in a Python virtual environment: $VIRTUAL_ENV"
else
  echo "You are NOT in a Python virtual environment."
  echo "Please activate your Python virtual environment before running this script."
  echo "Run the following to activate your Python Virtual Environment: source ~/GitHub/Main/HashiCorp_Vault/.venv/bin/activate"
  exit 1
fi

FILE=~/"GitHub/Main/HashiCorp_Vault/.env"
INIT_FILE=~/"GitHub/Main/HashiCorp_Vault/vault/data/vault-init.json"

# Check if the .env file exists, if not create it
if [ ! -f "$FILE" ]; then
  #touch "$FILE"
  echo "The .env file '$FILE' created."
else
  echo "The .env file '$FILE' already exists."
fi

# This tells Docker Compose to build and run the containers in the background in (“detached mode”).
docker-compose up --build -d

# Wait for the containers to start
echo "Waiting for containers to start..."
wait_time=30 # seconds

# Extract the Vault root token from the initialization file.
ROOT_TOKEN=$(jq -r '.root_token' "$INIT_FILE")
# Login with root token
# VAULT_TOKEN="$ROOT_TOKEN" vault login "$ROOT_TOKEN" > /dev/null

echo "Check ~/GitHub/Main/HashiCorp_Vault/vault/data/vault-init.json for the root token."
echo "The token is: ${ROOT_TOKEN}"
echo "You can use this token to access the Vault UI at https://127.0.0.1:8200"
echo "your certificates are in ~/GitHub/Main/HashiCorp_Vault/vault/Certs"

# Get the logs from the Vault container
docker-compose logs -f vault_server