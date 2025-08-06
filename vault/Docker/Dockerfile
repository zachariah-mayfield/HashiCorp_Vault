# ~/GitHub/Main/HashiCorp_Vault/vault/Docker/Dockerfile

# Pulls the Vault v1.13.3 image (Community Edition).  
# https://hub.docker.com/_/vault/tags
# vault:latest - to use the latest version
FROM vault:1.13.3

USER root

# Install jq (lightweight JSON processor) and Curl using Alpine's package manager and gettext-base (for envsubst)
RUN apk update && \
    apk add --no-cache curl jq gettext

# Copy your scripts and templates into the image
COPY Scripts /vault/Scripts
COPY Templates /vault/Templates
COPY config /vault/config

# Make sure scripts are executable
RUN chmod +x /vault/Scripts/*.sh

# Switch back to default vault user (good practice)
# Use default Vault user again
# This is the default Linux user inside the vault:1.13.3 Docker image. Not the PostgreSQL user vaultuser
USER vault

# Use your custom entrypoint that renders the vault config template and then starts Vault
ENTRYPOINT ["/bin/sh", "/vault/Scripts/start_hashicorp_vault.sh"]

# Default Vault command to run
CMD ["vault", "server"]