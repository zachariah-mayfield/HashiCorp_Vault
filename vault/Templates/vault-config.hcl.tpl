# ~/GitHub/Main/HashiCorp_Vault/vault/Templates/vault-config.hcl.tpl
# connection_url = "postgres://<user>:<password>@<Docker_Container_Name_For_Postgres>:<5432>/<database_name>?sslmode=disable"

ui = true

disable_mlock = true

storage "postgresql" {
  connection_url = "postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@vault_postgres:5432/${POSTGRES_DB}?sslmode=disable"
  table          = "vault_kv_store"
}
listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_cert_file      = "/vault/certs/vault-server.crt"
  tls_key_file       = "/vault/certs/vault-server.key"
  tls_client_ca_file = "/vault/certs/rootCA.crt"
  tls_require_and_verify_client_cert = false
  tls_min_version      = "tls12"   # Force minimum TLS 1.2
  tls_max_version      = "tls13"   # Optional, allows TLS 1.3 only
}
api_addr = "https://127.0.0.1:8200"
