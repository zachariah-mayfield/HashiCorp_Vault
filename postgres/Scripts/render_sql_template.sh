#!/bin/bash
# ~/GitHub/Main/HashiCorp_Vault/postgres/Scripts/render_sql_template.sh
set -euo pipefail

echo "Starting init.sql.tpl rendering..."

# Render the template to the actual init.sql file, substituting env vars
envsubst < /docker-entrypoint-initdb.d/init.sql.tpl > /docker-entrypoint-initdb.d/init.sql

# Also save a copy of rendered SQL to the mounted Config folder on host
envsubst < /docker-entrypoint-initdb.d/init.sql.tpl > /Config/init.sql

echo "init.sql rendered successfully:"
cat /docker-entrypoint-initdb.d/init.sql

echo "Processed postgres/init.sql with .env variables"

echo "Handing off to original PostgreSQL entrypoint..."
# Exec the original postgres docker-entrypoint.sh with all passed arguments
exec docker-entrypoint.sh "$@"

# Exit so Postgres runs init.sql and continues boot
exit 0