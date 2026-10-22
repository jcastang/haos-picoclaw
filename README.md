# PicoClaw for Home Assistant

Home Assistant add-on packaging the official PicoClaw Launcher image and exposing its web console through Home Assistant Ingress.

## Install

1. Add `https://github.com/jcastang/haos-picoclaw` under **Settings → Apps → App store → Repositories**.
2. Install **PicoClaw** and start it.
3. Open **Open Web UI**, or enable **Show in sidebar** to add a Home Assistant panel.

The add-on does not publish port 18800 or the gateway port on the Home Assistant host. Browser traffic enters through the internal NGINX proxy on port 8099.

## First launch and authentication

The upstream Launcher provides its own browser-based setup and configuration UI. On first launch, follow the Launcher prompt to create a dashboard password (the upstream setup route is `/launcher-setup`). Use the Launcher UI to configure models, providers, channels, and the gateway.

Current upstream PicoClaw uses password-based dashboard authentication. `PICOCLAW_LAUNCHER_TOKEN` is deprecated and ignored by current upstream versions, so this add-on does not set it. The dashboard password hash and Launcher settings live alongside `config.json`; the add-on persists the whole `/root/.picoclaw` directory in Home Assistant's `/data` storage.

## Ingress compatibility

Home Assistant Ingress serves an app beneath a per-session URL prefix. This add-on's NGINX proxy strips the Ingress prefix from incoming requests and forwards them to the Launcher. However, reverse-proxy prefix compatibility also depends on how the upstream frontend constructs asset, API, and WebSocket URLs. The upstream Launcher image does not currently expose a documented base-path option; if some UI resources fail under Ingress, this requires a verified frontend-side solution rather than exposing port 18800 directly.

## Data and security

- PicoClaw's home and config are persisted in `/data` using `PICOCLAW_HOME`, `PICOCLAW_CONFIG`, and a `/root/.picoclaw` symlink.
- `PICOCLAW_GATEWAY_HOST=0.0.0.0` matches the upstream Launcher Docker Compose configuration so the Launcher can communicate with its gateway inside the container.
- NGINX restricts inbound requests to Home Assistant Supervisor's Ingress proxy address (`172.30.32.2`); no host port is published.
- Do not expose the Launcher directly to untrusted networks.
- This add-on does not automatically configure Home Assistant entity tools or grant PicoClaw access to the Home Assistant API.

## Changelog

See [CHANGELOG.md](CHANGELOG.md).
