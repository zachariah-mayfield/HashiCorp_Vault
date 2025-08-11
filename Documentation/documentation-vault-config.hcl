# ~/GitHub/Main/HashiCorp_Vault/vault-config.hcl
# vault-config.hcl — Vault Configuration File
# This config:
# Tells Vault how to start and where to store data
# Use PostgreSQL for storage - Provides persistent storage (not memory-only)
# Listen on port 8200 (insecure for now)
# Enable the Vault UI
# disable_mlock = true is needed for Docker.
# tls_disable = true is for learning — I will secure it later.
# postgres://user:pass@host:port/db is standard PostgreSQL format.
# # connection_url = "postgres://user:pass@localhost:5432/database?sslmode=disable"

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


# tls_cert_file -> This is the path to the TLS certificate Server file for the Vault server.
# tls_key_file -> This is the path to the TLS key Server file for the Vault server.
# tls_client_ca_file -> This is the path to the TLS CA certificate (From my Mac) file for the Vault server.
# tls_require_and_verify_client_cert -> If true, Vault will require and verify client certificates.
# tls_min_version -> This sets the minimum TLS version that Vault will accept.
# tls_max_version -> This sets the maximum TLS version that Vault will accept.
# This block sets Vault’s configuration via an inline JSON config passed through the VAULT_LOCAL_CONFIG env variable.
# "ui": true: Enables the Vault web UI.
# "listener": Defines how Vault listens for incoming connections.
# "address": "0.0.0.0:8200": Listen on all network interfaces. Bind to all network interfaces on port 8200. &
# “Vault will accept connections from any source interface (loopback, container network, LAN) on port 8200.”
# Inside a Docker container, Vault listens on 0.0.0.0:8200 this makes it reachable from your host machine
# "tls_disable": true: Disables TLS (only for development/testing).
# "storage": Tells Vault to use PostgreSQL as its backend.
# "connection_url": Connects to the postgres service using provided user/pass.
# "disable_mlock": true: Required inside Docker — skips memory locking (not secure but necessary in containers).  