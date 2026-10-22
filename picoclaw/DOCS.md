# PicoClaw

PicoClaw Launcher is proxied through Home Assistant Ingress on internal port 8099. No host port is published.

## First start

Open the app's **Open Web UI** button or enable **Show in sidebar**. Configure your provider and API key in PicoClaw.

## Ingress limitation

Home Assistant gives each Ingress session a changing URL prefix. Nginx forwards requests and the `X-Ingress-Path` header to PicoClaw, but the upstream Launcher frontend may request absolute paths such as `/assets/...` or `/api/...`. Those paths can escape the Ingress prefix. This packaging enables Ingress, but complete compatibility depends on the upstream frontend supporting a base path or relative URLs.

## Home Assistant integration

This app does not by itself give PicoClaw access to Home Assistant entities or the Home Assistant API. Configure a supported tool/MCP bridge separately if desired.
