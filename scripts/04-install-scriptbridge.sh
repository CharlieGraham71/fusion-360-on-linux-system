#!/usr/bin/env bash
# Install the ScriptBridge add-in (runs .py files dropped into ~/fusion-bridge/inbox).
# NOTE: the add-in hard-codes Z:\home\graham\fusion-bridge – edit INBOX/DONE for other users.
set -euo pipefail
source "$(dirname "$0")/common.sh"
DEST="$WINEPREFIX/drive_c/users/$USER/AppData/Roaming/Autodesk/Autodesk Fusion 360/API/AddIns/ScriptBridge"
mkdir -p "$DEST" "$HOME/fusion-bridge/inbox" "$HOME/fusion-bridge/done"
cp "$(dirname "$0")/../addins/ScriptBridge/"* "$DEST/"
echo "Installed to $DEST – restart Fusion."
