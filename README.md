# PicoClaw for Home Assistant

Home Assistant app packaging the PicoClaw Web Launcher and exposing it through Home Assistant Ingress.

## Install

1. Add `https://github.com/jcastang/haos-picoclaw` under **Settings → Apps → App store → Repositories**.
2. Install **PicoClaw** and start it.
3. Open **Open Web UI**, or enable **Show in sidebar** to add a Home Assistant panel.

The app does not publish port 18800 on the host. Ingress traffic enters through the internal Nginx proxy on port 8099.

## Important compatibility note

Home Assistant Ingress serves apps beneath a per-session URL prefix. The PicoClaw Launcher frontend must support that prefix for all API, asset, and WebSocket requests. This repository configures Ingress and proxies requests, but the upstream Launcher does not document a dedicated base-path setting. If the page loads but assets/API calls fail, the upstream frontend needs a relative-URL/base-path fix before this can be considered fully working.

This app does not automatically configure Home Assistant entity tools or grant PicoClaw access to the Home Assistant API.

## Security

Ingress requests are restricted to Home Assistant Supervisor's ingress proxy address (172.30.32.2). Do not expose the Launcher directly to an untrusted network.
