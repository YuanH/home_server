# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal home server configuration using Docker Compose, managing media automation and monitoring services across two machines:
- **88** (`docker-compose-88.yml`) — the "88morgan" machine
- **255** (`docker-compose-255.yaml`) — the "255" machine (more feature-rich, includes monitoring)

## Starting Services

Secrets are managed via 1Password CLI (`op`). Always use the start scripts, not `docker compose` directly.

```bash
# For the 88 machine
chmod +x 88-start.sh && ./88-start.sh

# For the 255 machine
chmod +x 255-start.sh && ./255-start.sh
```

The start scripts: sign into 1Password, pull secrets, pull latest images, then bring up containers. The 255 script uses `--force-recreate --remove-orphans`.

To manage individual services:
```bash
docker compose -f docker-compose-255.yaml logs -f <service>
docker compose -f docker-compose-255.yaml restart <service>
docker compose -f docker-compose-255.yaml down
```

## Architecture

### Services (both machines)
- **qbittorrent** `:8080` — torrent client
- **prowlarr** `:9696` — indexer manager
- **sonarr** `:8989` — TV show automation
- **radarr** `:7878` — movie automation
- **bazarr** `:6767` — subtitle management
- **sabnzbd** `:8081` — Usenet downloader
- **flaresolverr** `:8191` — Cloudflare bypass for indexers
- **cloudflared** — Cloudflare Tunnel for external access

### 255-only services
- **whisparr** `:6969` — adult content automation
- **cadvisor** `:8082` — container metrics
- **node_exporter** `:9100` — host metrics for Prometheus

### Monitoring (255, via `prometheus.yml`)
Prometheus scrapes exporters for each *arr service, cadvisor, node_exporter, and cloudflared. Grafana uses Prometheus as its default datasource (`grafana/datasource.yml`).

### Networking
The project switched from Caddy reverse proxy to Cloudflare Tunnel for external access. The `Dockerfile` builds a custom Caddy image with the Cloudflare DNS plugin (used by the legacy `Caddyfile`).

## Environment Variables

**88 machine** (`COMMON_PATH_88`, `TZ`, `CLOUDFLARE_TUNNEL_TOKEN`)

**255 machine** (`COMMON_PATH`, `TZ`, `CLOUDFLARE_API_TOKEN`, `CLOUDFLARE_TUNNEL_TOKEN`, plus API keys for each *arr service)

All secrets are stored in 1Password and injected at startup — never hardcoded.

## Config & Data Layout

- `./config/<service>/` — persistent config for each service (committed to git)
- `$COMMON_PATH` / `$COMMON_PATH_88` — external media storage root (not in repo)
  - `.../media/tv`, `.../media/movies`, `.../media/books` — media libraries
  - `.../qbittorrent/downloads` or `.../torrents` — download directories

## Known Issues

macOS creates `._*` (AppleDouble) files on non-macOS filesystems that can cause library scanning issues in *arr apps. Use `dot_clean <directory>` to remove them.
