#!/usr/bin/env bash
# Launch Fusion (DXVK, quiet logs). Set DEBUG=1 for DXVK + Wine error logs in /tmp.
source "$(dirname "$0")/common.sh"
EXE="$(fusion_exe)"; [ -n "$EXE" ] || { echo "Fusion360.exe not found"; exit 1; }
cd "$(dirname "$EXE")"
if [ "${DEBUG:-0}" = 1 ]; then
  mkdir -p /tmp/dxvklog
  DXVK_LOG_LEVEL=info DXVK_LOG_PATH=/tmp/dxvklog WINEDEBUG=-all,+err wine Fusion360.exe > /tmp/fusion.log 2>&1 &
else
  DXVK_LOG_LEVEL=none WINEDEBUG=-all wine Fusion360.exe >/dev/null 2>&1 &
fi
disown; echo "Fusion starting…"
