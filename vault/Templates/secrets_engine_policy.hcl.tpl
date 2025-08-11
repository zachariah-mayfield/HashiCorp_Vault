# ~/GitHub/Main/HashiCorp_Vault/vault/Templates/secrets_engine_policy.hcl.tpl

path "sys/mounts/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "${SECRETS_PATH}/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "${SECRETS_PATH}/metadata/*" {
  capabilities = ["list"]
}

path "auth/token/create" {
  capabilities = ["update"]
}

path "auth/token/lookup-self" {
  capabilities = ["read"]
}

path "auth/token/revoke-self" {
  capabilities = ["update"]
}
