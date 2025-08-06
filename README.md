# HashiCorp Vault community edition in server mode using postgresql for persistent storage
- Vault (Community Edition) using:
- Docker Compose
- PostgreSQL as persistent backend
- Automated initialization and unseal

### To run this Application all you need to do is clone this repository, set up your .env file, and then chmod +x ~/GitHub/Main/HashiCorp_Vault/Scripts/Run_HashiCorp_Vault_Application.sh and then run that shell script.

- I have containerized Hashicorp Vault. I have created 3 Docker Containers. vault_server, vault_postgres, and vault_pgadmin. I created a docker-compose.yml and 3 Dockerfile files to run all of this. I created many shell scripts to do everything including preforming  the initialization and unseal of the vault server. I created sql and hcl templates to incorporate a ,env file for var secrets. I have also wrote a ReadMe file and more documentation in the documentation folder. and all of this run from a python virtual environmment. This app is portable and persistent once setup. This is the first commit after getting everything set up and running correctly. I will add more later.

## HashiCorp_Vault
- HashiCorp Vault Community Edition Server Mode - 

## Stop and Rebuild containers:
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
# To check everything inside the container:
docker exec -it vault_server sh
```

```bash
# bash

```

## Visit Vault UI:
- http://localhost:8200
- use your token from: ~/GitHub/Main/HashiCorp_Vault/vault/data/vault-init.json --> "root_token": ""

## Visit pgadmin UI:
- http://localhost:8080/browser/

# Things to do:
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
