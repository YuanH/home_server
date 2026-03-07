#!/usr/bin/env bash
set -euo pipefail

# 1. Sign in to 1Password
eval "$(op signin)"

# 2. Retrieve secrets from 1Password
# CLOUDFLARE_API_TOKEN="$(op item get "Cloudflare Caddy API Token" --field credential --reveal)"
CLOUDFLARE_TUNNEL_TOKEN="$(op item get "cloudflare-tunnel-88" --field credential --reveal)"
SONARR_API_KEY="$(op item get "sonarr-api-key-88" --field credential --reveal)"
RADARR_API_KEY="$(op item get "radarr-api-key-88" --field credential --reveal)"
PROWLARR_API_KEY="$(op item get "prowlarr-api-key-88" --field credential --reveal)"
SABNZBD_API_KEY="$(op item get "sabnzbd-api-key-88" --field credential --reveal)"
READARR_API_KEY="$(op item get "readarr-api-key-88" --field credential --reveal)"
BAZARR_API_KEY="$(op item get "bazarr-api-key-88" --field credential --reveal)"

# 3. Export them as environment variables
# export CLOUDFLARE_API_TOKEN
export CLOUDFLARE_TUNNEL_TOKEN
export SONARR_API_KEY
export RADARR_API_KEY
export PROWLARR_API_KEY
export SABNZBD_API_KEY
export READARR_API_KEY
export BAZARR_API_KEY

# 4. Start podman machine
podman machine start 2>/dev/null || true

# 5. Pull latest images
podman compose -f podman-compose-88.yaml pull

# 6. Run podman compose
podman compose -f podman-compose-88.yaml up -d --force-recreate --remove-orphans
