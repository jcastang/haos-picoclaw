# Changelog

All notable changes to this Home Assistant add-on are documented here. Newest entries first.

## [0.1.6] - 2026-10-22

### Changed
- Build a dedicated minimal Alpine runtime image instead of extending `ghcr.io/sipeed/picoclaw:launcher`.
- Compile the official `picoclaw` and `picoclaw-launcher` binaries from the same pinned upstream source revision using the upstream frontend and Go build workflow.
- Pin the upstream source revision through `PICOCLAW_REF` for reproducible builds.
- Include only the runtime binaries and required Alpine packages in the final image.
- Update the README to describe the custom image, source pin, and required Ingress validation.

### Maintained
- Keep `config.yaml` and `build.yaml` version metadata aligned at `0.1.6`.
- Continue routing browser traffic through Home Assistant Ingress and internal NGINX; no host port is published.
- Preserve PicoClaw home, Launcher settings, and authentication data in `/data`.

### Validation
- Repository files and upstream build instructions reviewed.
- A Home Assistant add-on image build and live Ingress test have not yet been run; verify both before treating this release as production-ready.

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
