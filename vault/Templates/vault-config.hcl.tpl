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
  tls_disable = 1
}