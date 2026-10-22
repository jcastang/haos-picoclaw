# Pin the upstream source commit so image builds are reproducible.
ARG PICOCLAW_REF=bbf6893ca7afad27f1d00a0f5a45982a549c6ed6

# Build the embedded web frontend.
FROM node:24-alpine3.23 AS frontend
ARG PICOCLAW_REF
RUN apk add --no-cache git
WORKDIR /src
RUN git init && git remote add origin https://github.com/sipeed/picoclaw.git \
    && git fetch --depth 1 origin "${PICOCLAW_REF}" \
    && git checkout --detach FETCH_HEAD
WORKDIR /src/web/frontend
RUN corepack enable && corepack prepare pnpm@10.33.0 --activate
RUN CI=true pnpm install --frozen-lockfile
RUN pnpm build:backend

# Build both official Go binaries against the matching upstream source.
FROM golang:1.25-alpine AS builder
ARG PICOCLAW_REF
RUN apk add --no-cache git make
WORKDIR /src
RUN git init && git remote add origin https://github.com/sipeed/picoclaw.git \
    && git fetch --depth 1 origin "${PICOCLAW_REF}" \
    && git checkout --detach FETCH_HEAD
COPY --from=frontend /src/web/backend/dist /src/web/backend/dist
RUN go mod download
RUN make build
RUN CONFIG_PKG=github.com/sipeed/picoclaw/pkg/config && \
    VERSION=$(git describe --tags --always --dirty 2>/dev/null || echo dev) && \
    GIT_COMMIT=$(git rev-parse --short=8 HEAD 2>/dev/null || echo dev) && \
    BUILD_TIME=$(date +%FT%T%z) && \
    GO_VERSION=$(go env GOVERSION) && \
    CGO_ENABLED=0 go build -v -tags goolm,stdjson \
      -ldflags "-X ${CONFIG_PKG}.Version=${VERSION} -X ${CONFIG_PKG}.GitCommit=${GIT_COMMIT} -X ${CONFIG_PKG}.BuildTime=${BUILD_TIME} -X ${CONFIG_PKG}.GoVersion=${GO_VERSION} -s -w" \
      -o build/picoclaw-launcher ./web/backend/

# Minimal runtime: official PicoClaw binaries plus our Home Assistant proxy.
FROM alpine:3.23
ARG BUILD_VERSION
ARG BUILD_ARCH
ARG PICOCLAW_REF

LABEL \
  io.hass.name="PicoClaw" \
  io.hass.description="PicoClaw Launcher integrated through Home Assistant Ingress" \
  io.hass.type="app" \
  io.hass.version="${BUILD_VERSION}" \
  io.hass.arch="${BUILD_ARCH}" \
  org.opencontainers.image.title="PicoClaw" \
  org.opencontainers.image.description="PicoClaw built from official source for Home Assistant Ingress" \
  org.opencontainers.image.source="https://github.com/sipeed/picoclaw" \
  org.opencontainers.image.revision="${PICOCLAW_REF}"

RUN apk add --no-cache bash ca-certificates tzdata curl nginx \
    && mkdir -p /run/nginx
COPY --from=builder /src/build/picoclaw /usr/local/bin/picoclaw
COPY --from=builder /src/build/picoclaw-launcher /usr/local/bin/picoclaw-launcher
COPY nginx.conf /etc/nginx/http.d/default.conf
COPY run.sh /run.sh
RUN chmod 0755 /run.sh
ENTRYPOINT ["/bin/bash", "/run.sh"]
