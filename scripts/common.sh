# Shared settings, sourced by the other scripts.
export WINEPREFIX="${WINEPREFIX:-$HOME/.autodesk_fusion/wineprefixes/default}"
FUSION_PROD="$WINEPREFIX/drive_c/Program Files/Autodesk/webdeploy/production"
# Newest Fusion360.exe (Fusion updates create a new hash folder)
fusion_exe() { find "$FUSION_PROD" -maxdepth 2 -name Fusion360.exe -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -1 | cut -d' ' -f2-; }
