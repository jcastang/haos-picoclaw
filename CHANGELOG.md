# Changelog

All notable changes to this Home Assistant add-on are documented here. Newest entries first.

## [0.1.5] - 2026-10-22

### Changed
- Set `PICOCLAW_GATEWAY_HOST=0.0.0.0` to match the upstream Launcher Docker Compose configuration and allow internal Launcher-to-Gateway communication.
- Document the upstream Launcher password setup and note that `PICOCLAW_LAUNCHER_TOKEN` is deprecated and ignored by current upstream versions.
- Clarify persistent storage for the complete PicoClaw home, including Launcher settings and authentication data.
- Document the remaining limitation around upstream frontend URL handling under Home Assistant Ingress.

### Maintained
- Keep `config.yaml` and `build.yaml` version metadata aligned at `0.1.5`.
- Continue routing external browser traffic through Home Assistant Ingress and the internal NGINX proxy; no host port is published.

## [0.1.4]

### Changed
- Enabled Home Assistant Ingress streaming.
- Added NGINX access and error logs to the add-on log stream.

### Fixed
- Added an NGINX rewrite for requests carrying the Home Assistant Ingress URL prefix.

## [0.1.3]

### Changed
- Persisted PicoClaw home and configuration in the add-on's `/data` directory.
- Explicitly set `PICOCLAW_HOME` and `PICOCLAW_CONFIG`.
