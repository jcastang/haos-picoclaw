#!/usr/bin/env bash
set -Eeuo pipefail

DATA_DIR="/data"
PICO_DIR="/root/.picoclaw"

mkdir -p "${DATA_DIR}" /run/nginx

# The Launcher stores config, workspace, launcher settings, and authentication
# data under ~/.picoclaw. Persist the whole directory across add-on upgrades.
if [[ ! -L "${PICO_DIR}" ]]; then
  if [[ -d "${PICO_DIR}" && -n "$(ls -A "${PICO_DIR}" 2>/dev/null || true)" ]]; then
    cp -an "${PICO_DIR}/." "${DATA_DIR}/"
  fi
  rm -rf "${PICO_DIR}"
  ln -s "${DATA_DIR}" "${PICO_DIR}"
fi

# These variables are independent in PicoClaw; set both explicitly.
export PICOCLAW_HOME="${DATA_DIR}"
export PICOCLAW_CONFIG="${DATA_DIR}/config.json"

# Match the upstream Docker Compose Launcher profile. The gateway is only
# reachable on the add-on's internal network; host ports are not published.
export PICOCLAW_GATEWAY_HOST="0.0.0.0"

echo "[PicoClaw app] Persistent home: ${PICOCLAW_HOME}"
echo "[PicoClaw app] Config file: ${PICOCLAW_CONFIG}"
echo "[PicoClaw app] Gateway bind host: ${PICOCLAW_GATEWAY_HOST}"
echo "[PicoClaw app] Checking NGINX configuration..."
# Do not silently fall back to a proxy without Ingress asset rewriting.
# Such a fallback makes the add-on look healthy but breaks every /assets/* URL.
nginx -t 2>&1 || { echo "[PicoClaw app] FATAL: NGINX configuration invalid"; exit 1; }
echo "[PicoClaw app] Starting Launcher bound to 127.0.0.1:18800"
/usr/local/bin/picoclaw-launcher -console -port 18800 -host 127.0.0.1 -no-browser &
launcher_pid=$!

cleanup() {
  kill "${launcher_pid}" 2>/dev/null || true
}
trap cleanup EXIT TERM INT

echo "[PicoClaw app] Starting NGINX Ingress listener on port 8099"
nginx -g 'daemon off;'
