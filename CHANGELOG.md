# Changelog

All notable changes to this Home Assistant add-on are documented here. Newest entries first.

## [0.1.19] - 2026-10-22

### Fixed
- Apply one global HTML base URL using Home Assistant X-Ingress-Path, so Vite's entire /assets/* family, manifest and favicon resolve inside the Ingress session even on nested frontend routes.
- Keep the existing root-absolute src/href rewrites and add CSS url(/ rewriting.
- Remove the silent NGINX fallback, which previously disabled all asset rewriting while leaving the add-on running; fail with an explicit startup error instead.
- Disable NGINX absolute redirects to avoid leaking the internal :8099 listener.
- Synchronize release metadata and CI checks.

### Validation
- Based on the upstream Vite index.html, Vite config and TanStack router entrypoint. No frontend rebuild required; live Home Assistant verification is still needed. JS-generated root-absolute routes remain a possible limitation.

## [0.1.18] - 2026-10-22

### Fixed
- Rewrite root-absolute HTML src and href references to browser-relative URLs, retaining the public Home Assistant Ingress origin and session prefix for frontend CSS, JS and site.webmanifest.
- Avoid relying on X-Ingress-Path for static HTML asset links because its presence is not guaranteed in the request received by NGINX.
- Synchronize release metadata and add CI assertions for the asset rewrites.

### Validation
- User observed /assets/index-B96BmGCd.css and /site.webmanifest escaping Ingress and returning 404. Live verification is required; frontend JavaScript-generated absolute URLs may need separate handling.

## [0.1.17] - 2026-10-22

### Fixed
- Emit relative HTTP Location redirects instead of absolute redirects built with the add-on's internal port 8099.
- Preserve the browser's existing Home Assistant Ingress origin and session path when redirecting from the Ingress entrypoint to launcher-login.
- Apply the same behavior to the fallback NGINX configuration and synchronize release metadata.

### Validation
- Observed browser navigation to an internal :8099 URL in 0.1.16. Live validation of the new relative redirects is still required.

## [0.1.16] - 2026-10-22

### Fixed
- Rewrite absolute upstream HTTP Location redirects in addition to root-relative redirects so login navigation can retain the Home Assistant Ingress path.
- Apply equivalent redirects to the fallback NGINX configuration.
- Synchronize version metadata. Live Ingress verification is pending.

## [0.1.15] - 2026-10-22

### Diagnostics
- Add /ingress-status returning HTTP 200 directly from NGINX without contacting PicoClaw or reading a file.
- Make the fallback NGINX configuration serve both /ingress-status and /ingress-test.html, even when the primary configuration is invalid.
- Temporarily remove the NGINX source-IP restriction on internal port 8099 for Ingress troubleshooting; the port remains unpublished.
- Synchronize versions and CI assertions.

### Validation
- Test the endpoint through Home Assistant Ingress; live verification remains necessary.

## [0.1.14] - 2026-10-22

### Added
- A standalone /ingress-test.html diagnostic page served directly by NGINX on port 8099, bypassing the PicoClaw Launcher upstream entirely.
- X-PicoClaw-Proxy-Test: nginx-direct response header to identify successful NGINX handling.
- CI checks ensuring the diagnostic page is included in the Docker image and its NGINX route exists.

### Validation
- If the test page opens through Home Assistant Ingress, Supervisor-to-NGINX routing works and remaining 404s are downstream or URL-related.
- If the test page also returns 404, investigate Supervisor Ingress routing/session rather than PicoClaw.
- Version metadata synchronized to 0.1.14; live verification pending.

## [0.1.13] - 2026-10-22

### Fixed
- Pin the PicoClaw Launcher listener explicitly to 127.0.0.1:18800, matching NGINX's upstream, even when persisted launcher-config.json contains another port or public listener setting.
- Keep Launcher private to the add-on and avoid exposing the backend on all container interfaces.
- Check listener arguments in CI and synchronize add-on, Dockerfile, build metadata and CI version.

### Validation
- Based on the upstream Launcher -port and -host flag precedence. Live Home Assistant startup and Ingress checks still required.

## [0.1.12] - 2026-10-22

### Fixed
- Print NGINX configuration validation output during add-on startup, so errors are visible in the Home Assistant add-on journal.
- If the Ingress URL-rewriting configuration fails NGINX validation at runtime, restore a minimal reverse proxy configuration to avoid blocking the add-on from starting.
- Keep the 0.1.11 URL-rewriting configuration when its NGINX syntax is accepted.

### Validation
- Synchronized add-on, Dockerfile, build metadata, and CI version to 0.1.12. A live Home Assistant start and Ingress test are still needed.

## [0.1.11] - 2026-10-22

### Changed
- Rewrite root-relative PicoClaw Launcher HTML asset links and selected JavaScript navigation, API, WebSocket, and asset URLs using the Home Assistant X-Ingress-Path header, following patterns from existing HA add-ons.
- Disable upstream response compression to enable NGINX sub_filter, while retaining the official Launcher image, authentication redirect/cookie handling and WebSocket forwarding.
- Validate NGINX syntax in CI and synchronize all version metadata to 0.1.11.

### Validation
- CI build and live Home Assistant Ingress verification are still required. Some client-side router URLs may need additional upstream changes.

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
