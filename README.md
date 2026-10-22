# PicoClaw for Home Assistant (amd64)

A Home Assistant OS app wrapper for the official PicoClaw Launcher + managed Gateway container.

- Upstream image: `ghcr.io/sipeed/picoclaw:launcher`
- Launcher UI: TCP `18800`
- PicoClaw configuration/workspace: persisted in the app's `/data` volume
- Architecture: `amd64`

**Scope:** this repository currently packages PicoClaw's Launcher and Gateway. It does not implement Home Assistant API tools or automatically grant PicoClaw control of HA entities. See [`picoclaw/DOCS.md`](picoclaw/DOCS.md).

## Repository setup

Add `https://github.com/jcastang/haos-picoclaw` under Home Assistant **Settings → Apps → App store → ⋮ → Repositories**, then install PicoClaw.
