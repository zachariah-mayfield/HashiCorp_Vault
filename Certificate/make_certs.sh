#!/bin/bash
# ~/GitHub/Main/HashiCorp_Vault/Certificate/make_certs.sh

set -e

# The directory where the Certificate will be stored
OUT_DIR="$HOME/GitHub/Main/HashiCorp_Vault/vault/Certs"

# CA config
CA_NAME="rootCA"
CA_CRT_FILE="${OUT_DIR}/${CA_NAME}.crt"
CA_KEY_FILE="${OUT_DIR}/${CA_NAME}.key"
CA_CommonName="rootCA"
CA_Organization="Zachariah Inc"
CA_OrganizationalUnit="Vault"

# Server config
SERVER_NAME="vault-server"
SERVER_CRT_FILE="${OUT_DIR}/${SERVER_NAME}.crt"
SERVER_KEY_FILE="${OUT_DIR}/${SERVER_NAME}.key"
SERVER_CSR_FILE="${OUT_DIR}/${SERVER_NAME}.csr"
SERVER_CommonName="vault_server"
SERVER_Organization="Zachariah Inc"
SERVER_OrganizationalUnit="Vault"

# Client config
CLIENT_NAME="vault-client"
CLIENT_CRT_FILE="${OUT_DIR}/${CLIENT_NAME}.crt"
CLIENT_KEY_FILE="${OUT_DIR}/${CLIENT_NAME}.key"
CLIENT_CSR_FILE="${OUT_DIR}/${CLIENT_NAME}.csr"
CLIENT_CommonName="vault-client"
CLIENT_Organization="Zachariah Inc"
CLIENT_OrganizationalUnit="Vault"

# OpenSSL config file
CERT_CONFIG_FILE="${OUT_DIR}/cert_config.conf"

# Create OpenSSL config
cat > "$CERT_CONFIG_FILE" <<EOF
[ req ]
default_bits       = 4096
prompt             = no
default_md         = sha256
req_extensions     = req_ext
distinguished_name = dn

[ dn ]
C  = US
ST = Florida
L  = Gulf_Breeze
O  = Zachariah Inc
OU = Vault
CN = vault_server

[ req_ext ]
subjectAltName = @alt_names

[alt_names]
IP.1 = 127.0.0.1
DNS.1 = localhost
DNS.2 = vault_server
DNS.3 = vault-server
EOF

# Root CA key (keep safe)
openssl genrsa -out "$CA_KEY_FILE" 4096

# Root CA certificate (valid 10 years)
openssl req -x509 -new -nodes \
  -key "$CA_KEY_FILE" \
  -sha256 -days 3650 \
  -out "$CA_CRT_FILE" \
  -subj "/C=US/ST=Florida/L=Gulf_Breeze/O=Zachariah Inc/OU=Vault/CN=rootCA"

# Server key
openssl genrsa -out "${SERVER_KEY_FILE}" 4096

# Server CSR
SERVER_CSR_FILE="${OUT_DIR}/${SERVER_NAME}.csr"
openssl req -new -key "${SERVER_KEY_FILE}" \
  -out "${SERVER_CSR_FILE}" \
  -subj "/C=US/ST=Florida/L=Gulf_Breeze/O=Zachariah Inc/OU=Vault/CN=${SERVER_CommonName}" \
  -reqexts req_ext \
  -config "$CERT_CONFIG_FILE"

# Sign with CA - Server certificate
openssl x509 -req -in "${SERVER_CSR_FILE}" \
  -CA "${CA_CRT_FILE}" -CAkey "${CA_KEY_FILE}" -CAcreateserial \
  -out "${SERVER_CRT_FILE}" -days 825 -sha256 \
  -extfile "$CERT_CONFIG_FILE" -extensions req_ext

# Client key
openssl genrsa -out "${CLIENT_KEY_FILE}" 4096

# Client CSR
openssl req -new -key "${CLIENT_KEY_FILE}" \
  -out "${CLIENT_CSR_FILE}" \
  -config "$CERT_CONFIG_FILE"

# Sign with CA - Client certificate
openssl x509 -req -in "${CLIENT_CSR_FILE}" \
  -CA "${CA_CRT_FILE}" -CAkey "${CA_KEY_FILE}" -CAcreateserial \
  -out "${CLIENT_CRT_FILE}" -days 825 -sha256 \
  -extfile "$CERT_CONFIG_FILE" -extensions req_ext
