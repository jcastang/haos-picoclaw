# PicoClaw for Home Assistant

Home Assistant add-on that builds its own minimal Alpine image from the official [PicoClaw source repository](https://github.com/sipeed/picoclaw), then exposes the Launcher web console through Home Assistant Ingress. It does not use or extend the upstream prebuilt Docker image.

## Install

1. Add `https://github.com/jcastang/haos-picoclaw` under **Settings → Apps → App store → Repositories**.
2. Install **PicoClaw** and start it.
3. Open **Open Web UI**, or enable **Show in sidebar** to add a Home Assistant panel.

The add-on builds the official `picoclaw` and `picoclaw-launcher` binaries from a pinned upstream source commit. Only the runtime binaries and required Alpine packages are included in the final image. The add-on does not publish port 18800 or the gateway port on the Home Assistant host; browser traffic enters through the internal NGINX proxy on port 8099.

## First launch and authentication

The upstream Launcher provides its own browser-based setup and configuration UI. On first launch, follow the Launcher prompt to create a dashboard password (the upstream setup route is `/launcher-setup`). Use the Launcher UI to configure models, providers, channels, and the gateway.

Current upstream PicoClaw uses password-based dashboard authentication. `PICOCLAW_LAUNCHER_TOKEN` is deprecated and ignored by current upstream versions, so this add-on does not set it. The dashboard password hash and Launcher settings live alongside `config.json`; the add-on persists the whole `/root/.picoclaw` directory in Home Assistant's `/data` storage.

## Upstream source pin

The upstream source revision is configured by `PICOCLAW_REF` in `picoclaw/build.yaml`. It is deliberately pinned for reproducible builds; update it only after reviewing upstream changes and testing the resulting add-on. The frontend and both Go binaries are built from that same revision.

## Ingress compatibility

Home Assistant Ingress serves an app beneath a per-session URL prefix. This add-on's NGINX proxy strips the Ingress prefix from incoming requests and forwards them to the Launcher. Reverse-proxy prefix compatibility also depends on how the upstream frontend constructs asset, API, and WebSocket URLs. Building our own image gives us control over the runtime, but does not by itself fix an upstream frontend that assumes it is served from `/`. Validate UI assets, API calls, authentication, and WebSockets through Ingress before considering this integration complete.

## Data and security

- PicoClaw's home and config are persisted in `/data` using `PICOCLAW_HOME`, `PICOCLAW_CONFIG`, and a `/root/.picoclaw` symlink.
- `PICOCLAW_GATEWAY_HOST=0.0.0.0` allows Launcher-to-Gateway communication inside the container.
- NGINX restricts inbound requests to Home Assistant Supervisor's Ingress proxy address (`172.30.32.2`); no host port is published.
- Do not expose the Launcher directly to untrusted networks.
- This add-on does not automatically configure Home Assistant entity tools or grant PicoClaw access to the Home Assistant API.

## Changelog

See [CHANGELOG.md](CHANGELOG.md).
