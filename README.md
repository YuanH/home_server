# Home Server

## Prerequisite

- github
- one password cli
- docker desktop
- cloudflare-tunnel

## How to Run

`chmod +x 88-start.sh && ./88-start.sh`

or

`chmod +x 255-start.sh && ./255-start.sh`

~~`docker compose -f docker-compose-255.yml up -d`~~

## Caddy vs. Cloudflare tunnel

This project initially utilizes caddy as a reverse proxy, currently switching over to cloudflare tunnel

## Credentials

Since this is a personal project, all credentials have been moved to 1password.

## Problem with library scanning

### What are ._* files?

AppleDouble(._*) files: macOS creates these hidden files (e.g., ._filename.ext) to store extended attributes and resource forks for files on non-macOS file systems (like FAT32, exFAT, NTFS). They are invisible in Finder by default but can clutter directories and cause permission issues in applications like Jellyfin.

The current, imperfect solution is to use `dot_clean` command to get rid of all of these files.
