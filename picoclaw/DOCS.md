# PicoClaw for Home Assistant

This Home Assistant app wraps the official PicoClaw Launcher container for `amd64`. The Launcher serves its web UI on TCP port `18800` and manages the Gateway process.

## Install

1. In Home Assistant, open **Settings → Apps → App store → ⋮ → Repositories** (older releases may call these Add-ons).
2. Add `https://github.com/jcastang/haos-picoclaw` as a repository.
3. Install **PicoClaw** and start it.
4. Open `http://HOME_ASSISTANT_IP:18800` and follow the Launcher setup to create a dashboard password.
5. Configure a model provider and its API key in the Launcher, then start the Gateway.

PicoClaw's configuration and workspace are stored in the app's persistent `/data` directory.

## Home Assistant API integration status

This release is a Launcher/Gateway wrapper only. It does **not** yet provide PicoClaw with Home Assistant-specific tools, and it does not pass a Home Assistant access token into the app. To control HA entities, a separate supported MCP/tool integration or an explicitly configured bridge must be installed and tested. Do not assume that installing this app alone enables Home Assistant control.

## Security

- On first start, create a strong Launcher dashboard password.
- Do not forward port `18800` from your router or expose the Launcher directly to the Internet.
- Keep model-provider API keys private.
- Before enabling any future Home Assistant tool bridge, start with read-only access and a narrow allowlist of entities/actions.
- Back up the app data before upgrades.

## Troubleshooting

- If the app exits immediately, inspect the app log and verify that the upstream `ghcr.io/sipeed/picoclaw:launcher` image remains compatible.
- If the UI is unavailable, verify port `18800` and the app log.
