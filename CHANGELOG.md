# Changelog

All notable changes to this Home Assistant add-on are documented here. Newest entries first.

## [0.1.10] - 2026-10-22

### Fixed
- Rewrite Launcher root-relative HTTP redirects (including the first unauthenticated `/launcher-login` redirect) to the Home Assistant Ingress session path, preventing the browser from escaping Ingress and landing on a Home Assistant 404.
- Scope Launcher authentication cookies to the Ingress session prefix.
- Preserve the official Launcher image, existing upstream routing, WebSocket proxy and persistent data.

### Validation
- Add CI assertions for the Ingress redirect and cookie rewrite rules.
- Synchronize add-on, Dockerfile, build metadata and CI version to `0.1.10`.
- A successful CI build and real Home Assistant Ingress test remain necessary. The upstream frontend also uses absolute paths for some browser-side navigation and API requests; those are not fixed by this HTTP redirect change.

## [0.1.9] - 2026-10-22

### Changed
- Return to the original integration approach: use the official `ghcr.io/sipeed/picoclaw:launcher` image instead of compiling PicoClaw inside the add-on build.
- Keep the Home Assistant-specific layer focused on installing NGINX and proxying the Launcher through Ingress.
- Remove the custom frontend/Go build stages and the now-unneeded `PICOCLAW_REF` build argument.
- Update the README and CI checks to describe and verify the upstream-image approach.

### Maintained
- Preserve the existing Ingress prefix rewrite, WebSocket proxy settings, Supervisor-only NGINX access rule, and persistent `/data` storage.
- Synchronize add-on, Docker image, build metadata, and validation workflow version to `0.1.9`.

### Validation
- Repository configuration and Docker build workflow updated; a successful GitHub Actions image build and live Home Assistant Ingress test are still required.

## [0.1.8] - 2026-10-22

### Fixed
- Remove the strict frozen-lockfile check from the frontend dependency installation, which was the failing step reported by the CI Docker build.
- Keep the frontend source and package manifests pinned to the same upstream commit; dependencies are resolved during the image build if its lockfile needs reconciliation.
- Synchronize add-on, Docker image, build metadata, and validation workflow version to `0.1.8`.

### Validation
- The reported failure occurs during `pnpm install --frozen-lockfile`; the Dockerfile now uses `pnpm install --no-frozen-lockfile`.
- The updated GitHub Actions run still needs to complete to confirm the subsequent frontend and Go compilation stages.

## [0.1.7] - 2026-10-22

### Fixed
- Remove the obsolete `BUILD_FROM` argument from the validation pipeline; the custom multi-stage Dockerfile builds from pinned upstream source and does not consume a prebuilt base image.
- Update the CI build metadata from the stale `0.1.2` value to `0.1.7`.
- Give Docker image metadata arguments defaults so direct local builds and CI builds do not produce empty version/architecture labels.
- Fail the Docker build immediately if either expected upstream binary was not produced.
- Add a validation assertion that the Home Assistant add-on version and build metadata remain aligned.

### Maintained
- Keep `config.yaml`, `build.yaml`, the Dockerfile defaults, and CI build arguments aligned at `0.1.7`.
- Continue building the core and Launcher from the same pinned upstream source revision and preserve the existing Ingress/proxy and persistent-storage configuration.

### Validation
- Reviewed the validation workflow and compared the build commands with the pinned upstream Makefile and frontend package scripts.
- GitHub Actions must complete the new image build to confirm the fix in CI; no successful build is claimed before that run finishes.

## [0.1.6] - 2026-10-22

### Changed
- Build a dedicated minimal Alpine runtime image instead of extending `ghcr.io/sipeed/picoclaw:launcher`.
- Compile the official `picoclaw` and `picoclaw-launcher` binaries from the same pinned upstream source revision using the upstream frontend and Go build workflow.
- Pin the upstream source revision through `PICOCLAW_REF` for reproducible builds.
- Copy the architecture-specific core binary into the runtime image and include only runtime binaries and required Alpine packages in the final image.
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
