#!/bin/bash
# ~/GitHub/Main/HashiCorp_Vault/Certificate/create_root_CA.sh

set -e

# The directory where the Certificate will be stored
OUT_DIR="$HOME/GitHub/Main/HashiCorp_Vault/vault/Certs"

# CA config
CA_NAME="Zachariah_MacBook_CA"
CA_CRT_FILE="${OUT_DIR}/${CA_NAME}.crt"
CA_KEY_FILE="${OUT_DIR}/${CA_NAME}.key"
CA_CommonName="MacBook_CA"
CA_Organization="MacBook_CA"
CA_OrganizationalUnit="MacBook_CA"

# Subject info
Country="US"
State="Florida"
Locality="Gulf_Breeze"
DAYS_VALID=36500

# Vault server cert
SERVER_NAME="HashiCorp_Vault"
SERVER_CRT_FILE="${OUT_DIR}/${SERVER_NAME}.crt"
SERVER_KEY_FILE="${OUT_DIR}/${SERVER_NAME}.key"
SERVER_CSR_FILE="${OUT_DIR}/${SERVER_NAME}.csr"
SERVER_PEM_FILE="${OUT_DIR}/${SERVER_NAME}.pem"
SERVER_FULLCHAIN_FILE="${OUT_DIR}/${SERVER_NAME}-fullchain.pem"

# Vault client cert
CLIENT_NAME="Vault_Client"
CLIENT_CRT_FILE="${OUT_DIR}/${CLIENT_NAME}.crt"
CLIENT_KEY_FILE="${OUT_DIR}/${CLIENT_NAME}.key"
CLIENT_CSR_FILE="${OUT_DIR}/${CLIENT_NAME}.csr"
CLIENT_PEM_FILE="${OUT_DIR}/${CLIENT_NAME}.pem"
CLIENT_FULLCHAIN_FILE="${OUT_DIR}/${CLIENT_NAME}-fullchain.pem"
CLIENT_PFX_FILE="${OUT_DIR}/${CLIENT_NAME}.pfx"

# OpenSSL config file
CERT_CONFIG_FILE="${OUT_DIR}/cert_config.conf"

# Create OpenSSL config
cat > "$CERT_CONFIG_FILE" <<EOF
[req]
distinguished_name = req_distinguished_name
prompt = no

[req_distinguished_name]
CN = 127.0.0.1

[v3_server]
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[v3_client]
keyUsage = critical, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth
subjectAltName = @alt_names

[v3_ca]
basicConstraints = critical, CA:true
keyUsage = critical, digitalSignature, cRLSign, keyCertSign
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer

[alt_names]
IP.1 = 127.0.0.1
DNS.1 = localhost
DNS.2 = vault_server
EOF

# Create output directory
mkdir -p "$OUT_DIR"

echo "Generating Root CA..."
openssl genrsa -out "$CA_KEY_FILE" 4096
openssl req -x509 -new -nodes \
  -key "$CA_KEY_FILE" \
  -sha256 \
  -days 3650 \
  -out "$CA_CRT_FILE" \
  -subj "/C=$Country/ST=$State/L=$Locality/O=$CA_Organization/OU=$CA_OrganizationalUnit/CN=$CA_CommonName" \
  -config "$CERT_CONFIG_FILE" \
  -extensions v3_ca

echo "Generating Vault server certificate..."
openssl genrsa -out "$SERVER_KEY_FILE" 2048
openssl req -new -key "$SERVER_KEY_FILE" \
  -out "$SERVER_CSR_FILE" \
  -subj "/C=$Country/ST=$State/L=$Locality/O=HashiCorp_Vault/CN=127.0.0.1" \
  -config "$CERT_CONFIG_FILE" \
  -reqexts v3_server
openssl x509 -req \
  -in "$SERVER_CSR_FILE" \
  -CA "$CA_CRT_FILE" \
  -CAkey "$CA_KEY_FILE" \
  -CAcreateserial \
  -out "$SERVER_CRT_FILE" \
  -days "$DAYS_VALID" \
  -sha256 \
  -extfile "$CERT_CONFIG_FILE" \
  -extensions v3_server
cat "$SERVER_CRT_FILE" "$SERVER_KEY_FILE" > "$SERVER_PEM_FILE"
cat "$SERVER_CRT_FILE" "$SERVER_KEY_FILE" "$CA_CRT_FILE" > "$SERVER_FULLCHAIN_FILE"

echo "Generating Vault client certificate for mTLS..."
openssl genrsa -out "$CLIENT_KEY_FILE" 2048
openssl req -new -key "$CLIENT_KEY_FILE" \
  -out "$CLIENT_CSR_FILE" \
  -subj "/C=$Country/ST=$State/L=$Locality/O=Vault_Client/CN=Vault_Client" \
  -config "$CERT_CONFIG_FILE" \
  -reqexts v3_client
openssl x509 -req \
  -in "$CLIENT_CSR_FILE" \
  -CA "$CA_CRT_FILE" \
  -CAkey "$CA_KEY_FILE" \
  -CAcreateserial \
  -out "$CLIENT_CRT_FILE" \
  -days "$DAYS_VALID" \
  -sha256 \
  -extfile "$CERT_CONFIG_FILE" \
  -extensions v3_client
cat "$CLIENT_CRT_FILE" "$CLIENT_KEY_FILE" > "$CLIENT_PEM_FILE"
cat "$CLIENT_CRT_FILE" "$CLIENT_KEY_FILE" "$CA_CRT_FILE" > "$CLIENT_FULLCHAIN_FILE"

openssl pkcs12 -export \
  -out "$CLIENT_PFX_FILE" \
  -inkey "$CLIENT_KEY_FILE" \
  -in "$CLIENT_CRT_FILE" \
  -certfile "$CA_CRT_FILE" \
  -name "Vault Client Cert" \
  -passout pass:

echo "All certificates successfully created in: $OUT_DIR"
