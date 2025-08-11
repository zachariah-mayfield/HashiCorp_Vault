#!/bin/bash
# ~/GitHub/Main/HashiCorp_Vault/Scripts/Build_Scripts/Run_HashiCorp_Vault_Application.sh

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

# Start the HashiCorp Vault application using Docker Compose
docker-compose down

# This tells Docker Compose to run the containers in the background (“detached mode”).
docker-compose up -d --build

# Wait for the containers to start
echo "Waiting for containers to start..."
wait_time=30 # seconds

# Get the logs from the Vault container
docker-compose logs -f vault_server

# Extract the Vault root token from the initialization file.
ROOT_TOKEN=$(jq -r '.root_token' "$INIT_FILE")
if [ -z "$ROOT_TOKEN" ]; then
  echo "Error: Root token not found in $INIT_FILE"
  exit 1
fi

echo "Check ~/GitHub/Main/HashiCorp_Vault/vault/data/vault-init.json for the root token."
echo "The token is: ${ROOT_TOKEN}"
echo "You can use this token to access the Vault UI at https://localhost:8200."