#!/bin/bash
# ~/GitHub/Main/HashiCorp_Vault/initialization_and_auto-unseal.sh

# Automates Vault startup (safe, using JSON and jq):
# - Initializes Vault (only once)
# - Saves unseal keys + root token to file
# - Unseals Vault
# - Logs in with root token

set -euo pipefail

export VAULT_ADDR="http://127.0.0.1:8200"

INIT_FILE="/vault/file/vault-init.json"

echo "Checking Vault status..."

# Vault must be reachable for this to work
VAULT_STATUS=$(vault status 2>/dev/null || true)

if echo "$VAULT_STATUS" | grep -q '^Initialized *true'; then
  echo "Vault is already initialized. Skipping init."
else
  echo "Vault is not initialized. Initializing now..."
  vault operator init -key-shares=5 -key-threshold=3 -format=json > "$INIT_FILE"
  echo "Vault initialized. Keys written to $INIT_FILE"
fi

# Check for Init File
if [[ ! -f "$INIT_FILE" ]]; then
  echo "Error: Init file $INIT_FILE not found!"
  exit 1
fi

# Load from file (whether just created or already existing)
KEY1=$(jq -r '.unseal_keys_b64[0]' "$INIT_FILE")
KEY2=$(jq -r '.unseal_keys_b64[1]' "$INIT_FILE")
KEY3=$(jq -r '.unseal_keys_b64[2]' "$INIT_FILE")
ROOT_TOKEN=$(jq -r '.root_token' "$INIT_FILE")

# Check if Vault is sealed
if echo "$VAULT_STATUS" | grep -q '^Sealed *true'; then
  echo "Vault is sealed. Proceeding to unseal..."
  vault operator unseal "$KEY1"
  vault operator unseal "$KEY2"
  vault operator unseal "$KEY3"
else
  echo "Vault is already unsealed."
fi

# Login with root token
VAULT_TOKEN="$ROOT_TOKEN" vault login "$ROOT_TOKEN" > /dev/null
echo "Vault is unsealed and logged in."