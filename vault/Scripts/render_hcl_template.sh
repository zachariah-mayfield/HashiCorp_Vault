#!/bin/bash
# ~/GitHub/Main/HashiCorp_Vault/vault/Scripts/render_hcl_template.sh

set -euo pipefail

echo "Rendering vault-config.hcl from template..."

envsubst < /vault/Templates/vault-config.hcl.tpl > /vault/config/vault-config.hcl

echo "vault-config.hcl rendered successfully:"
cat /vault/config/vault-config.hcl

# Hand off to original Vault start script
#exec /vault/Scripts/start_hashicorp_vault.sh

exec vault server -config=/vault/config/vault-config.hcl