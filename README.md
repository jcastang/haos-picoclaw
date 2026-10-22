# PicoClaw for Home Assistant

Home Assistant add-on that uses the official prebuilt [PicoClaw Launcher Docker image](https://github.com/sipeed/picoclaw/pkgs/container/picoclaw) and adds NGINX as a reverse proxy for Home Assistant Ingress. The add-on no longer compiles PicoClaw from source during its own image build.

## Install

1. Add `https://github.com/jcastang/haos-picoclaw` under **Settings → Apps → App store → Repositories**.
2. Install **PicoClaw** and start it.
3. Open **Open Web UI**, or enable **Show in sidebar** to add a Home Assistant panel.

The image is based on `ghcr.io/sipeed/picoclaw:launcher`. This add-on layer installs NGINX and routes browser traffic from Home Assistant Ingress to the Launcher on internal port 18800. It does not publish port 18800 or the gateway port on the Home Assistant host.

## First launch and authentication

The upstream Launcher provides its own browser-based setup and configuration UI. On first launch, follow the Launcher prompt to create a dashboard password (the upstream setup route is `/launcher-setup`). Use the Launcher UI to configure models, providers, channels, and the gateway.

The add-on persists PicoClaw's home, including configuration, workspace, Launcher settings, and authentication data, in Home Assistant's `/data` storage. It sets `PICOCLAW_HOME`, `PICOCLAW_CONFIG`, and `PICOCLAW_GATEWAY_HOST=0.0.0.0` for the container.

## Ingress compatibility

Home Assistant Ingress serves the app beneath a per-session URL prefix. NGINX strips the Ingress prefix from incoming requests and forwards them to the Launcher. Reverse-proxy prefix compatibility also depends on how the upstream frontend constructs asset, API, and WebSocket URLs. Validate UI assets, API calls, authentication, and WebSockets through Ingress after installation.

## Data and security

- PicoClaw's home and config are persisted in `/data` using a `/root/.picoclaw` symlink.
- `PICOCLAW_GATEWAY_HOST=0.0.0.0` allows Launcher-to-Gateway communication inside the container.
- NGINX restricts inbound requests to Home Assistant Supervisor's Ingress proxy address (`172.30.32.2`); no host port is published.
- Do not expose the Launcher directly to untrusted networks.
- This add-on does not automatically configure Home Assistant entity tools or grant PicoClaw access to the Home Assistant API.

## Changelog

See [CHANGELOG.md](CHANGELOG.md).
