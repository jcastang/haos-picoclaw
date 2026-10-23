# Reuse the official upstream image; do not modify the PicoClaw frontend.
FROM ghcr.io/sipeed/picoclaw:launcher
ARG BUILD_VERSION=0.1.0
LABEL io.hass.name="PicoClaw Terminal" \
      io.hass.version="${BUILD_VERSION}" \
      io.hass.type="app" \
      org.opencontainers.image.source="https://github.com/jcastang/haos-picoclaw"
USER root
RUN apk add --no-cache bash ttyd && command -v picoclaw && command -v ttyd
COPY run.sh /run.sh
RUN chmod 0755 /run.sh
ENTRYPOINT ["/bin/bash", "/run.sh"]
