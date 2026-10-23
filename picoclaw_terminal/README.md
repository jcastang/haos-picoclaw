# PicoClaw Terminal (Home Assistant add-on)

Alternative add-on alongside the existing PicoClaw Launcher; the original add-on is unchanged.

- Official upstream PicoClaw binary (from the official Launcher container)
- Interactive web shell via **ttyd** in Home Assistant Ingress
- Background `picoclaw gateway` for Discord and other configured channels
- Persistent PicoClaw home/configuration under `/data`
- No PicoClaw frontend, NGINX substitutions, public host port or Docker socket

## First start

1. Install **PicoClaw Terminal** from this repository and open its Ingress panel.
2. Run `picoclaw --help`, then `picoclaw onboard`.
3. Configure your LLM provider and Discord channel in `/data/config.json` using the PicoClaw documentation.
4. Restart the add-on to start the Discord gateway in the background.
5. Use the web terminal for administration; closing the browser tab does not stop the gateway.

The web terminal provides a shell **inside the add-on container**, not a host HAOS shell.

## Home Assistant control and configuration

The add-on does **not** automatically grant PicoClaw access to Home Assistant or its YAML files.
Configure an explicitly authorized Home Assistant API/MCP integration for device control.
Editing HA configuration requires a separate, restricted integration and confirmation/backup
workflow; this initial add-on deliberately does not mount the HA configuration or Docker socket.

## Security

Ingress provides the Home Assistant entry point, but the terminal is privileged **within
the add-on container**. Restrict Home Assistant administrator access and never expose port
8099 directly. Use Discord user allowlists and restrict the agent's available tools.
