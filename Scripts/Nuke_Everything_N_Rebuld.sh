#!/bin/bash
# ~/GitHub/Main/HashiCorp_Vault/Scripts/Nuke_Everything_N_Rebuld.sh

# Remove Vault file that holds Keys and Token
echo "removing vault-init.json"
rm -f "~/GitHub/Main/HashiCorp_Vault/vault/data/vault-init.json"
# Remove PostgreSQL config 
echo "removing init.sql"
rm -f "~/GitHub/Main/HashiCorp_Vault/postgres/Config/init.sql"
# Remove vault config 
echo "removing vault-config.hcl"
rm -f "~/GitHub/Main/HashiCorp_Vault/vault/config/vault-config.hcl"

# This is the core command that stops and removes the containers and networks defined in your container and remove any named volumes and clean up "orphan" containers.
docker-compose down --volumes --remove-orphans

# Remove all Docker Containers, Volumes, Images, Networks, and build cache
docker system prune --all --volumes --force

# This tells Docker Compose to run the containers in the background (“detached mode”).
docker-compose up -d --build