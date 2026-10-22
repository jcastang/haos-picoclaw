#!/usr/bin/env bash
set -Eeuo pipefail

DATA_DIR="/data"
PICO_DIR="/root/.picoclaw"

mkdir -p "${DATA_DIR}" /run/nginx

# Migrate any data baked into the base image, then keep PicoClaw's home
# in Home Assistant's persistent /data volume.
if [[ ! -L "${PICO_DIR}" ]]; then
  if [[ -d "${PICO_DIR}" && -n "$(ls -A "${PICO_DIR}" 2>/dev/null || true)" ]]; then
    cp -an "${PICO_DIR}/." "${DATA_DIR}/"
  fi
  rm -rf "${PICO_DIR}"
  ln -s "${DATA_DIR}" "${PICO_DIR}"
fi

# Explicitly direct PicoClaw and the Launcher to persistent storage.
# PICOCLAW_CONFIG is independent of PICOCLAW_HOME, so set both.
export PICOCLAW_HOME="${DATA_DIR}"
export PICOCLAW_CONFIG="${DATA_DIR}/config.json"

echo "[PicoClaw app] Persistent home: ${PICOCLAW_HOME}"
echo "[PicoClaw app] Config file: ${PICOCLAW_CONFIG}"
echo "[PicoClaw app] Starting Launcher on internal port 18800"
/usr/local/bin/picoclaw-launcher -console -public -no-browser &
launcher_pid=$!

cleanup() {
  kill "${launcher_pid}" 2>/dev/null || true
}
trap cleanup EXIT TERM INT

nginx -g 'daemon off;'
