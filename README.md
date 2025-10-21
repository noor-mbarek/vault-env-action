# 🔐 HashiCorp Vault Env Loader

This GitHub Action securely fetches secrets from HashiCorp Vault and makes them available either as exported environment variables or as a `.env` file.

## 🚀 Usage

```yaml
- uses: noor-mbarek/vault-env-action@v1
  with:
    vault_addr: ${{ secrets.VAULT_ADDR }}
    vault_role_id: ${{ secrets.VAULT_ROLE_ID }}
    vault_secret_id: ${{ secrets.VAULT_SECRET_ID }}
    vault_path: "secret/data/my-service"
    import_type: "env_file"
    export_path: "./.env"
