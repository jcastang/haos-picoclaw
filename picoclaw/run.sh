#!/usr/bin/env bash
set -Eeuo pipefail

DATA_DIR="/data"
PICO_DIR="/root/.picoclaw"

mkdir -p "${DATA_DIR}" /run/nginx

# The upstream Launcher image stores config, workspace, launcher settings,
# and launcher-auth.db under ~/.picoclaw. Keep that entire directory persistent.
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
echo "[PicoClaw app] Starting Launcher on internal port 18800"
/usr/local/bin/picoclaw-launcher -console -public -no-browser &
launcher_pid=$!

cleanup() {
  kill "${launcher_pid}" 2>/dev/null || true
}
trap cleanup EXIT TERM INT

nginx -g 'daemon off;'
