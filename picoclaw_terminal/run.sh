#!/usr/bin/env bash
set -Eeuo pipefail

# Keep the terminal and the background gateway on the same persistent home.
mkdir -p /data /root/.picoclaw
if [[ ! -L /root/.picoclaw ]]; then
  if [[ -d /root/.picoclaw && -n "$(ls -A /root/.picoclaw 2>/dev/null || true)" ]]; then
    cp -an /root/.picoclaw/. /data/
  fi
  rm -rf /root/.picoclaw
  ln -s /data /root/.picoclaw
fi
export PICOCLAW_HOME=/data
export PICOCLAW_CONFIG=/data/config.json
export HOME=/root
cd /data

gateway_pid=""
cleanup() {
  if [[ -n "$gateway_pid" ]]; then
    kill "$gateway_pid" 2>/dev/null || true
    wait "$gateway_pid" 2>/dev/null || true
  fi
}
trap cleanup EXIT TERM INT

# On first start, the user can run 'picoclaw onboard' in the web terminal.
# The gateway starts automatically after restarting the add-on.
if [[ -f /data/config.json ]]; then
  echo "[PicoClaw Terminal] Starting background gateway"
  picoclaw gateway &
  gateway_pid=$!
else
  echo "[PicoClaw Terminal] First run: open the terminal and run 'picoclaw onboard'."
  echo "[PicoClaw Terminal] Restart the add-on after configuring Discord and your model."
fi

# ttyd's only listener is the HA Ingress port. No host port is published.
# -W allows interactive input. -t disables terminal title changes.
echo "[PicoClaw Terminal] Web terminal listening on port 8099"
exec ttyd -W -i 0.0.0.0 -p 8099 -t titleFixed=PicoClaw /bin/bash -l
