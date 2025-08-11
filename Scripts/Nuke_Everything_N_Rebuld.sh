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