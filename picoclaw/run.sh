#!/usr/bin/env bash
set -Eeuo pipefail

DATA_DIR="/data"
PICO_DIR="/root/.picoclaw"

mkdir -p "${DATA_DIR}"

# Keep PicoClaw's config and workspace in Home Assistant's persistent app data.
if [[ ! -L "${PICO_DIR}" ]]; then
  if [[ -d "${PICO_DIR}" && -n "$(ls -A "${PICO_DIR}" 2>/dev/null || true)" ]]; then
    cp -an "${PICO_DIR}/." "${DATA_DIR}/"
  fi
  rm -rf "${PICO_DIR}"
  ln -s "${DATA_DIR}" "${PICO_DIR}"
fi

# The Launcher manages its Gateway process. -public makes the web UI reachable
# from the Home Assistant host; do not expose this port to the public Internet.
echo "[PicoClaw app] Starting Launcher; persistent data: ${DATA_DIR}"
exec /usr/local/bin/picoclaw-launcher -public
