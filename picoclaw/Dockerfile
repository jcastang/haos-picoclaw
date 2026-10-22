# Use the official prebuilt PicoClaw Launcher image. Home Assistant only
# adds the NGINX reverse proxy needed to expose it safely through Ingress.
FROM ghcr.io/sipeed/picoclaw:launcher

ARG BUILD_VERSION=0.1.26
ARG BUILD_ARCH=amd64

LABEL \
  io.hass.name="PicoClaw" \
  io.hass.description="Official PicoClaw Launcher integrated through Home Assistant Ingress" \
  io.hass.type="app" \
  io.hass.version="${BUILD_VERSION}" \
  io.hass.arch="${BUILD_ARCH}" \
  org.opencontainers.image.title="PicoClaw" \
  org.opencontainers.image.description="Official PicoClaw Launcher with an NGINX Ingress proxy" \
  org.opencontainers.image.source="https://github.com/sipeed/picoclaw"

USER root
RUN apk add --no-cache bash nginx \
    && mkdir -p /run/nginx

COPY nginx.conf /etc/nginx/http.d/default.conf
COPY ingress-test.html /usr/share/nginx/html/ingress-test.html
COPY run.sh /run.sh
RUN chmod 0755 /run.sh && nginx -t

ENTRYPOINT ["/bin/bash", "/run.sh"]
