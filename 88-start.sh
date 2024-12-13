#!/usr/bin/env bash
set -euo pipefail

# 1. Sign in to 1Password
# This assumes you have a 1Password account already added.
# If not, you may need: op account add --address <your 1p domain> and set it up
eval "$(op signin)"

# 2. Retrieve secrets from 1Password
# Adjust the item name and field names to match your setup.
# CLOUDFLARE_API_TOKEN="$(op item get "Cloudflare Caddy API Token" --field credential --reveal)"
CLOUDFLARE_TUNNEL_TOKEN="$(op item get "cloudflare-tunnel-88" --field credential --reveal)"

# 3. Export them as environment variables
# export CLOUDFLARE_API_TOKEN
export CLOUDFLARE_TUNNEL_TOKEN
echo $CLOUDFLARE_TUNNEL_TOKEN
# 4. Run docker-compose with these environment variables
docker compose -f docker-compose-88.yml up -d