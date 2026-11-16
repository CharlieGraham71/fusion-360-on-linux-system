#!/usr/bin/env bash
# Fix the WineHQ apt key, install wine-staging 11.10 and hold it.
# Why 11.10: 10.0 crashes on sign-in; 11.11+ breaks the 3D viewport (WineHQ bug 60010).
# STATUS: steps verified manually 16 Nov 2026; script not yet run end-to-end.
set -euo pipefail
VER=11.10~forky-1
source "$(dirname "$0")/common.sh"
wineserver -k 2>/dev/null || true
curl -fsSL https://dl.winehq.org/wine-builds/winehq.key \
  | sudo gpg --dearmor --yes -o /etc/apt/keyrings/winehq-archive.key
sudo apt update
sudo apt install -y --allow-downgrades --install-recommends "winehq-staging=$VER" "wine-staging=$VER"
sudo apt-mark hold winehq-staging wine-staging
wine --version
echo "Now run 02-update-prefix.sh"
