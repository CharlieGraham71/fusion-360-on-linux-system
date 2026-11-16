#!/usr/bin/env bash
# Refresh the Fusion prefix after a Wine version change.
# The installer disables auto-update (.update-timestamp = disable), so this is manual.
# A ".NET could not be started" box may appear: it is closed automatically.
# STATUS: steps verified manually 16 Nov 2026; script not yet run end-to-end.
set -uo pipefail
source "$(dirname "$0")/common.sh"
wineserver -k 2>/dev/null; sleep 2
rm -f "$WINEPREFIX/.update-timestamp"
WINEDEBUG=-all wine wineboot -u >/dev/null 2>&1 &
for _ in $(seq 1 60); do
  sleep 3
  pid=$(ps -eo pid,args | awk '/rundll32\.exe setupapi,InstallHinfSection/ && !/awk/ {print $1; exit}')
  [ -n "$pid" ] && { sleep 3; kill "$pid" 2>/dev/null && echo "closed .NET/mono dialog"; }
  ps -eo args | grep -q '[w]ineboot' || break
done
wineserver -w
echo disable > "$WINEPREFIX/.update-timestamp"
echo "Prefix updated."
