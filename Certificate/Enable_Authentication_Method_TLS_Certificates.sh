#!/bin/bash
# ~/GitHub/Main/HashiCorp_Vault/Certificate/Enable_Authentication_Method_TLS_Certificates.sh

CA_NAME="Zachariah_MacBook_CA"
CLIENT_NAME="HashiCorp_Vault"
CA_CRT_FILE="$HOME/GitHub/Main/HashiCorp_Vault/Certificate/Certificates/${CA_NAME}.crt"
CLIENT_CRT_FILE="$HOME/GitHub/Main/HashiCorp_Vault/Certificate/Certificates/${CLIENT_NAME}.crt"
CLIENT_KEY_FILE="$HOME/GitHub/Main/HashiCorp_Vault/Certificate/Certificates/${CLIENT_NAME}.key"

# Configure Vault to Trust Your CA:
vault auth enable cert

# Upload the CA's certificate:  "secret/data/certificates/Lenovo-T480/SSH_user_login"
vault write auth/cert/certs/my-org-ca \
    display_name="my-org-ca" \
    policies="default, secrets-engine-policy" \
    certificate=@${CA_CRT_FILE}

vault login -method=cert \
  client_cert=${CLIENT_CRT_FILE} \
  client_key=${CLIENT_KEY_FILE}

vault token lookup
vault kv get secret/myapp/config
