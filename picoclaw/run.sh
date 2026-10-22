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

echo "[PicoClaw app] Starting Launcher on internal port 18800"
/usr/local/bin/picoclaw-launcher -console -public -no-browser &
launcher_pid=$!

cleanup() {
  kill "${launcher_pid}" 2>/dev/null || true
}
trap cleanup EXIT TERM INT

nginx -g 'daemon off;'
