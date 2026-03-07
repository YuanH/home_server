# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This repo manages two home server instances, each on a different machine/drive, using Docker Compose or Podman Compose. All secrets are stored in 1Password and injected at runtime via the `op` CLI.

- **Branch `88`** — runs on this Mac using **Podman** + `/Volumes/ExtremeSSD`
- **Branch `255`** — runs on another machine using **Docker** + `/Volumes/ExtremePro`

## Starting Services

**Machine 88 (Podman):**
```bash
op signin   # must run first in the terminal session
./88-podman-start.sh
```

**Machine 255 (Docker):**
```bash
op signin
./255-start.sh
```

The start scripts: sign in to 1Password, export secrets as env vars, pull latest images, then bring up containers.

## Podman Machine Setup (88 only, one-time)

The Podman Linux VM requires explicit volume passthrough and must be rootful:

```bash
podman machine init --volume /Volumes/ExtremeSSD:/Volumes/ExtremeSSD --volume /Users/wenda:/Users/wenda
podman machine set --rootful
podman machine start
```

After initial setup, `./88-podman-start.sh` handles `podman machine start` automatically on subsequent runs. The machine config persists across reboots.

## Architecture

Each machine runs the same core media stack:

| Service | Port | Purpose |
|---|---|---|
| cloudflared | — | Cloudflare tunnel (replaces Caddy reverse proxy) |
| qbittorrent | 8080 | Torrent client |
| sabnzbd | 8081 | Usenet client |
| sonarr | 8989 | TV automation |
| radarr | 7878 | Movie automation |
| prowlarr | 9696 | Indexer management |
| bazarr | 6767 | Subtitle management |
| flaresolverr | 8191 | Cloudflare bypass for indexers |
| n8n | 5678 | Workflow automation (88 only) |
| node_exporter | 9100 | Host metrics |
| cadvisor | 8082 | Container metrics (255/Docker only — incompatible with Podman) |
| prometheus | 9090 | Metrics aggregation (255 only) |
| grafana | 3000 | Metrics dashboards (255 only) |

## Key Files

- `.env` — defines `COMMON_PATH` (255: `/Volumes/ExtremePro/data`) and `COMMON_PATH_88` (88: `/Volumes/ExtremeSSD/data`)
- `docker-compose-255.yaml` / `podman-compose-88.yaml` — active compose files per branch
- `docker-compose-88.yml` — legacy Docker version for the 88 machine (superseded by podman)
- `prometheus.yml` / `prometheus-88.yml` — Prometheus scrape configs
- `config/` — bind-mounted service configs (prowlarr, sonarr, radarr, etc.), committed to git
- `grafana/datasource.yml` — Grafana datasource provisioning

## Volume Layout on Drives

```
/Volumes/ExtremeSSD/data/   (88)
/Volumes/ExtremePro/data/   (255)
  torrents/
  media/
    tv/
    movies/
    books/
  usenet/
```

## macOS AppleDouble Files

macOS creates `._*` files on external drives that can cause issues with Jellyfin/media scanners. Clean them with:

```bash
dot_clean /Volumes/ExtremeSSD/data
```

## Updating a Single Container

```bash
podman pull <image:tag>
podman compose -f podman-compose-88.yaml up -d --force-recreate <service-name>
```

## Notes

- All containers use `PUID=0 / PGID=0` — rootful mode is required on Podman
- cAdvisor is Docker-specific (requires `/var/lib/docker/` and the Docker socket) — do not add it to `podman-compose-88.yaml`
- Cloudflare tunnel replaced Caddy as the reverse proxy; Caddy config (`Caddyfile`, `Dockerfile`) is kept but unused
