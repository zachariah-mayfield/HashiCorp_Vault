#!/bin/bash
# /vault/Scripts/start_hashicorp_vault.sh

set -euo pipefail

# Load environment .env loading
export SECRETS_PATH="secret"

export VAULT_ADDR='https://127.0.0.1:8200'
export VAULT_CACERT='/vault/certs/rootCA.crt'
export VAULT_CLIENT_CERT='/vault/certs/vault-client.crt'
export VAULT_CLIENT_KEY='/vault/certs/vault-client.key'

# Render vault-config.hcl
echo "Rendering vault-config.hcl from template..."
envsubst < /vault/Templates/vault-config.hcl.tpl > /vault/config/vault-config.hcl
echo "vault-config.hcl rendered:"
cat /vault/config/vault-config.hcl

# Render secrets_engine_policy.hcl
echo "Rendering secrets_engine_policy.hcl from template..."
envsubst < /vault/Templates/secrets_engine_policy.hcl.tpl > /vault/policies/secrets_engine_policy.hcl
echo "secrets_engine_policy.hcl rendered:"
cat /vault/policies/secrets_engine_policy.hcl

# Start Vault in background
echo "Starting Vault server in background..."
vault server -config=/vault/config/vault-config.hcl -log-level=debug &
VAULT_PID=$!

# Wait for Vault to become responsive
echo "Waiting for Vault to become responsive..."
until curl --cert $VAULT_CLIENT_CERT \
  --key $VAULT_CLIENT_KEY \
  --cacert $VAULT_CACERT \
  "$VAULT_ADDR/v1/sys/health" | \
  jq -e '.initialized != null' > /dev/null 2>&1; do
  echo "Vault not ready — retrying in 2s..."
  sleep 2
done
echo "Vault is up!"

# Run initialization/unseal logic (only on first run)
echo "Running initialization + unseal script..."
sh /vault/Scripts/initialization_and_auto-unseal.sh

# Keep Vault server in foreground
wait $VAULT_PID