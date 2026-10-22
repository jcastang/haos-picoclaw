#!/usr/bin/env bash
set -Eeuo pipefail

DATA_DIR="/data"
PICO_DIR="/root/.picoclaw"

mkdir -p "${DATA_DIR}" /run/nginx

if [[ ! -L "${PICO_DIR}" ]]; then
  if [[ -d "${PICO_DIR}" && -n "$(ls -A "${PICO_DIR}" 2>/dev/null || true)" ]]; then
    cp -an "${PICO_DIR}/." "${DATA_DIR}/"
  fi
  rm -rf "${PICO_DIR}"
  ln -s "${DATA_DIR}" "${PICO_DIR}"
fi

echo "[PicoClaw app] Starting Launcher on port 18800"
 /usr/local/bin/picoclaw-launcher -public &
launcher_pid=$!

cleanup() {
  kill "${launcher_pid}" 2>/dev/null || true
}
trap cleanup EXIT TERM INT

# Keep nginx in the foreground. Home Assistant Supervisor routes Ingress traffic
# to port 8099; nginx restricts direct access to the Supervisor network address.
nginx -g 'daemon off;'
