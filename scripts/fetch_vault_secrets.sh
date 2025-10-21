#!/usr/bin/env bash
set -euo pipefail

echo "🔐 Authenticating with Vault..."
VAULT_TOKEN=$(vault write -field=token auth/approle/login \
  role_id="$VAULT_ROLE_ID" \
  secret_id="$VAULT_SECRET_ID")

echo "📦 Fetching secrets from: $VAULT_PATH"
DATA=$(vault kv get -format=json -token="$VAULT_TOKEN" "$VAULT_PATH" | jq -r '.data.data')

if [[ "$IMPORT_TYPE" == "exported_env_vars" ]]; then
  echo "📤 Exporting environment variables..."
  echo "$DATA" | jq -r 'to_entries | .[] | "export \(.key)=\(.value)"' >> "$GITHUB_ENV"
  echo "✅ Secrets exported to environment."
else
  mkdir -p "$(dirname "$EXPORT_PATH")"
  echo "📝 Writing .env file to: $EXPORT_PATH"
  echo "$DATA" | jq -r 'to_entries | .[] | "\(.key)=\(.value)"' > "$EXPORT_PATH"
  echo "✅ .env file written successfully."
fi

# Clean up
unset VAULT_TOKEN
