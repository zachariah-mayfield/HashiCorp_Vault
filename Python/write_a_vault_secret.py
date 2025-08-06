import hvac
import os

# Load from environment (if using python-dotenv)
# from dotenv import load_dotenv
# load_dotenv()

VAULT_ADDR = os.getenv("VAULT_ADDR", "http://localhost:8200")
VAULT_TOKEN = os.getenv("VAULT_TOKEN")  # export VAULT_TOKEN=... before running

client = hvac.Client(url=VAULT_ADDR, token=VAULT_TOKEN)

if client.is_authenticated():
    print("Authenticated to Vault!")
    
    # Example: write a secret
    client.secrets.kv.v2.create_or_update_secret(
        path="myapp/config",
        secret={"api_key": "123456", "username": "zach"},
        mount_point="secret"
    )
    
    # Read it back
    secret = client.secrets.kv.v2.read_secret_version(
        path="myapp/config",
        mount_point="secret"
    )
    
    print("Secret data:", secret['data']['data'])

else:
    print("Failed to authenticate to Vault.")
