#!/usr/bin/env bash
set -euo pipefail

# 1. Sign in to 1Password
# This assumes you have a 1Password account already added.
# If not, you may need: op account add --address <your 1p domain> and set it up
eval "$(op signin)"

# 2. Retrieve secrets from 1Password
# Adjust the item name and field names to match your setup.
CLOUDFLARE_API_TOKEN="$(op item get "Cloudflare Caddy API Token" --field credential --reveal)"
CLOUDFLARE_TUNNEL_TOKEN="$(op item get "cloudflare-tunnel-255" --field credential --reveal)"
SONARR_API_KEY="$(op item get "sonarr-api-key-255" --field credential --reveal)"
RADARR_API_KEY="$(op item get "radarr-api-key-255" --field credential --reveal)"
PROWLARR_API_KEY="$(op item get "prowlarr-api-key-255" --field credential --reveal)"
SABNZBD_API_KEY="$(op item get "sabnzbd-api-key-255" --field credential --reveal)"
READARR_API_KEY="$(op item get "readarr-api-key-255" --field credential --reveal)"
BAZARR_API_KEY="$(op item get "bazarr-api-key-255" --field credential --reveal)"

# 3. Export them as environment variables
export CLOUDFLARE_API_TOKEN
export CLOUDFLARE_TUNNEL_TOKEN
export SONARR_API_KEY
export RADARR_API_KEY
export PROWLARR_API_KEY
export SABNZBD_API_KEY
export READARR_API_KEY
export BAZARR_API_KEY


# 4. Update Docker-Images
# Can be disabled if this step is taking too long
docker-compose -f docker-compose-255.yaml pull

# 5. Run docker-compose with these environment variables
docker compose -f docker-compose-255.yaml up -d