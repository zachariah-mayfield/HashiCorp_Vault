# ~/GitHub/Main/HashiCorp_Vault/postgres/Docker/Dockerfile

FROM postgres:15

# Install envsubst for variable substitution
RUN apt-get update && apt-get install -y gettext-base && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /docker-entrypoint-initdb.d/

# Copy the SQL template to a subdirectory (we'll render this at container start)
COPY postgres/Templates/init.sql.tpl /docker-entrypoint-initdb.d/init.sql.tpl

# Copy the custom entrypoint script
COPY postgres/Scripts/render_sql_template.sh /usr/local/bin/render_sql_template.sh

# Make sure the script is executable
RUN chmod +x /usr/local/bin/render_sql_template.sh

# This script runs first whenever the container starts. (responsible for any custom setup before launching PostgreSQL) Set the container’s ENTRYPOINT to the render SQL template script.
ENTRYPOINT ["/usr/local/bin/render_sql_template.sh"]

# Set the default command to run when the container starts, after the ENTRYPOINT script completes, this CMD is executed. It starts the PostgreSQL server.
CMD ["postgres"]