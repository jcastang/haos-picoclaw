ARG BUILD_FROM=ghcr.io/sipeed/picoclaw:launcher
FROM ${BUILD_FROM}

ARG BUILD_VERSION
ARG BUILD_ARCH
LABEL \
  io.hass.name="PicoClaw" \
  io.hass.description="PicoClaw Launcher and Gateway" \
  io.hass.type="app" \
  io.hass.version="${BUILD_VERSION}" \
  io.hass.arch="${BUILD_ARCH}"

USER root
RUN apk add --no-cache bash jq nginx
COPY nginx.conf /etc/nginx/http.d/default.conf
COPY run.sh /run.sh
RUN chmod 0755 /run.sh
ENTRYPOINT ["/bin/bash", "/run.sh"]
