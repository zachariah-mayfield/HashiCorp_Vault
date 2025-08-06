# HashiCorp Vault Community Edition — Docker + PostgreSQL Setup

## Overview:
- This repository provides a fully containerized deployment of HashiCorp Vault (Community Edition, Server Mode) backed by PostgreSQL, orchestrated via Docker Compose. It includes automated initialization, unseal, and a convenient web UI using pgAdmin for database visibility.

## About This Project:
- I have containerized Hashicorp Vault. I have created 3 Docker Containers. vault_server, vault_postgres, and vault_pgadmin. I created a docker-compose.yml and 3 Dockerfile files to run all of this. I created many shell scripts to do everything including preforming  the initialization and unseal of the vault server. I created sql and hcl templates to incorporate a ,env file for var secrets. I have also wrote a ReadMe file and more documentation in the documentation folder. and all of this run from a python virtual environmment. This app is portable and persistent once setup. This is the first commit after getting everything set up and running correctly. I will add more later.
    - Vault (Community Edition)
    - Docker Compose
    - PostgreSQL as persistent backend
    - Automated initialization and unseal
    - PGadmin for learning

- ChatGPT's Answer: This project provides a fully containerized deployment of HashiCorp Vault (Community Edition) in server mode, using PostgreSQL as a durable storage backend, and built for automation-first workflows using Docker Compose and shell scripts.
- It is designed for:
    - Learning and experimentation with HashiCorp Vault in a persistent, multi-container setup.
    - Infrastructure engineers or platform teams looking to integrate Vault into real-world container environments with PostgreSQL instead of file-based or in-memory storage.
    - Developers who want a reliable and reproducible way to stand up Vault services for local development or internal tooling.
    - Anyone wanting to explore how Vault handles initialization, auto-unsealing, secrets engines, access policies, and persistent backends.

## Architecture:
- vault_server – Vault Community Edition in server mode, auto‑initialized and unsealed.
- vault_postgres – PostgreSQL running as Vault’s persistent storage backend.
- vault_pgadmin – pgAdmin GUI to explore PostgreSQL and observe Vault state.
- Shell scripts and Python environment drive provisioning, setup, and persistence.

## Prerequisites:
- Docker & Docker Compose
- Unix-like shell (bash, zsh)
- Git
- Python virtual environment

## Setup:
1. Clone the repo:
```bash
# bash
git clone https://github.com/zachariah-mayfield/HashiCorp_Vault.git
cd HashiCorp_Vault
```

2. Create .env file:
```ini
# .env File
VAULT_ADDR=http://localhost:8200
POSTGRES_USER=<>
POSTGRES_PASSWORD=<>
POSTGRES_DB=<>
PGADMIN_DEFAULT_EMAIL=<>
PGADMIN_DEFAULT_PASSWORD=<>
```

3. Run the launcher script: 
```bash
# bash
chmod +x Scripts/Run_HashiCorp_Vault_Application.sh
./Scripts/Run_HashiCorp_Vault_Application.sh
```

4. Docker Compose will build and launch containers in detached (-d) mode:
- Vault UI: http://localhost:8200
    - Authenticate using the root_token value exported to vault/data/vault-init.json.
- pgAdmin UI: http://localhost:8080/browser/
    - Login with the credentials defined in your .env.

## Common Commands:
- Stop & Clean Up:
```bash
# bash
docker-compose down --volumes --remove-orphans
```

- Full Nuke & Rebuild:
```bash
# bash
# Remove containers, volumes, networks, images
docker-compose down --volumes --remove-orphans
docker system prune --all --volumes --force
# Delete generated Vault init files and PostgreSQL config:
rm vault/data/vault-init.json
rm vault/config/vault-config.hcl
rm postgres/Config/init.sql
```

- View Logs & Shell Access:
```bash
# bash
docker logs vault_server
docker exec -it vault_server sh
```

## Project Folder Structure:
```text
.
├── vault/            # Vault container & configuration files
├── postgres/         # SQL init script and configuration
├── pgadmin/          # pgAdmin Docker setup
├── Scripts/          # Automation scripts (initialization, cleanup, etc.)
├── docker-compose.yml
├── README.md
└── requirements.txt  # Python dependencies
```

## Features & Status:
| Feature                                | Status                       |
| -------------------------------------- | ---------------------------- |
| Docker‑based Vault + PostgreSQL        | Implemented                  |
| Automatic init & unseal                | Using shell scripts          |
| Persisted data across restarts         | Volumes enabled              |
| pgAdmin integration for DB visibility  | UI included                  |
| Idempotent provisioning (rebuild-safe) | Supports nuke & rebuild flow |
| Access policy management               | To‑do                        |

## Next Steps & Enhancement Ideas:
- Make pgAdmin optional via Compose profile or separate override.
- Remove any hard-coded values, fully rely on .env.
- Clean up folder structure and standardize naming.
- Build a dedicated pgAdmin Dockerfile, and unify folder hierarchy.
- Automate access policy creation, secrets engine enablement, and user roles.
- Add documentation for Vault policy files, example secrets mounts, and usage examples.

## Why This Approach:
- Vault + PostgreSQL enables encrypted, persistent storage across container restarts.
- Container diffs are stateless—script‑driven initialization avoids manual intervention.
- Auditable environment, ideal for learning, demos, and early-stage development.

## Troubleshooting Tips
- If the Vault UI reports not initialized or sealed, check vault-init.json.
- For database errors, verify .env matches the SQL init script inside postgres/Config/init.sql.
- If containers fail to build or run:
    - Confirm Docker Compose version compatibility.
    - Remove stale volumes/networks using prune commands above.

## Additional References: 
- Will add more here later ...............

## Key Capabilities This Project Implements:
- Key Capabilities This Project Implements
- Vault runs in server mode with a real database backend.
- Uses a custom shell script to:
    - Automatically initialize Vault on first boot
    - Unseal Vault using the saved unseal keys
    - Output the root token and unseal keys to a mounted location
- Provides a clean interface for exploring the PostgreSQL backend using pgAdmin
- Respects .env secrets and environment variables for secure, reproducible setups
- Allows full container rebuilds while maintaining state via Docker volumes
- Organizes scripts, configuration, and Dockerfiles into a clear and reusable structure

# Why PostgreSQL:
- PostgreSQL provides a production-ready, scalable, and industry-standard RDBMS as a backend that integrates well with Vault’s storage engine.

---

## How to Run:
- To run this Application all you need to do is clone this repository, set up your .env file, and then chmod +x ~/GitHub/Main/HashiCorp_Vault/Scripts/Run_HashiCorp_Vault_Application.sh and then run that shell script.

### Stop and Rebuild containers:
```bash
# bash
# Docker List Volumes
docker volume ls -q
# Docker list Images
docker images -q
# Docker List Networks
docker network ls -q
#############################################
# Remove all images
docker image prune --all --force
# Remove all volumes
docker volume prune --all --force
# Remove all Docker Networks
docker network prune --force 
#############################################
docker-compose down --volumes --remove-orphans
# Nuke Everything:
# Remove all Docker Containers, Volumes, Images, Networks, and build cache
docker system prune --all --volumes --force
########################################
# This tells Docker Compose to run the containers in the background (“detached mode”).
docker-compose up -d --build
#############################################
# View Docker vault_server container logs
docker logs vault_server
#############################################
```

```bash
# bash
# Place holder
```

### Visit Vault UI:
- http://localhost:8200
- use your token from: ~/GitHub/Main/HashiCorp_Vault/vault/data/vault-init.json --> "root_token": ""

### Visit pgadmin UI:
- http://localhost:8080/browser/

## Things to do:
- make pgadmin optional 
- remove any hard coding
- remove sensitive data -->DONE
- make sure it stops the container and restarts it without loosing its data -->DONE
- make sure its able to be blow away and recreated without issue -->DONE
- make pgadmin use a Dockerfile as well
- clean up folder structure
- create a Docker-Down script to:  -->DONE
    - bring the docker container down to be able to restart later when needed and persist data.  -->DONE
- create a Nuke-Everything script to:  -->DONE
    - docker-compose down --volumes --remove-orphans  -->DONE
    - (Start from Scratch)  -->DONE
    - remove: -->DONE
        - ~/GitHub/Main/HashiCorp_Vault/vault/data/vault-init.json -->DONE
        - ~/GitHub/Main/HashiCorp_Vault/vault/config/vault-config.hcl -->DONE
        - ~/GitHub/Main/HashiCorp_Vault/postgres/Config/init.sql -->DONE
- Create a Dockerfile for pgadmin and fix its folder structure.
- Finish updating and creating documentation.
- Incorporate adding an access policy to enable secrets engine, and finish configuring Vault.