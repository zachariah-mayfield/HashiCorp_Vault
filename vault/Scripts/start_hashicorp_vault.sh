#!/bin/bash
# /vault/Scripts/start_hashicorp_vault.sh

set -euo pipefail

export VAULT_ADDR="http://localhost:8200"

# Render vault-config.hcl
echo "Rendering vault-config.hcl from template..."
envsubst < /vault/Templates/vault-config.hcl.tpl > /vault/config/vault-config.hcl
echo "vault-config.hcl rendered:"
cat /vault/config/vault-config.hcl

# Start Vault in background
echo "Starting Vault server in background..."
vault server -config=/vault/config/vault-config.hcl -log-level=debug &
VAULT_PID=$!

# Wait for Vault to become responsive
echo "Waiting for Vault to become responsive..."
until curl -s "$VAULT_ADDR/v1/sys/health" | jq -e '.initialized != null' > /dev/null 2>&1; do
  echo "Vault not ready — retrying in 2s..."
  sleep 2
done
echo "Vault is up!"

# Run initialization/unseal logic (only on first run)
echo "Running initialization + unseal script..."
sh /vault/Scripts/initialization_and_auto-unseal.sh

# Keep Vault server in foreground
wait $VAULT_PID