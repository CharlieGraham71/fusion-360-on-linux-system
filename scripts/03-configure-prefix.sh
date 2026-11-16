#!/usr/bin/env bash
# DXVK overrides, 175 % UI scaling, and a Wine virtual desktop.
# Usage: 03-configure-prefix.sh [DPI] [WIDTHxHEIGHT]   (defaults 168 2560x1520)
# STATUS: settings verified manually 16 Nov 2026; script not yet run end-to-end.
set -euo pipefail
source "$(dirname "$0")/common.sh"
DPI="${1:-168}"; DESK="${2:-2560x1520}"
export WINEDEBUG=-all
wineserver -k 2>/dev/null || true; sleep 2
cp "$WINEPREFIX/user.reg" "$WINEPREFIX/user.reg.bak-$(date +%Y%m%d%H%M%S)"
for d in d3d11 dxgi d3d10core d3d9; do
  wine reg add 'HKCU\Software\Wine\DllOverrides' /v "$d"  /t REG_SZ /d native /f >/dev/null
  wine reg add 'HKCU\Software\Wine\DllOverrides' /v "*$d" /t REG_SZ /d native /f >/dev/null
done
wine reg add 'HKCU\Control Panel\Desktop' /v LogPixels /t REG_DWORD /d "$DPI" /f >/dev/null
wine reg add 'HKLM\System\CurrentControlSet\Hardware Profiles\Current\Software\Fonts' /v LogPixels /t REG_DWORD /d "$DPI" /f >/dev/null
wine reg add 'HKCU\Software\Wine\Explorer\Desktops' /v Default /t REG_SZ /d "$DESK" /f >/dev/null
wine reg add 'HKCU\Software\Wine\Explorer' /v Desktop /t REG_SZ /d Default /f >/dev/null
wineserver -w
echo "DXVK=native, LogPixels=$DPI, virtual desktop=$DESK"
