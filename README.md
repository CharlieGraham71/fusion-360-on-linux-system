# Autodesk Fusion on Kali Linux (Wine + DXVK)

A working setup for **Autodesk Fusion (Personal)** on **Kali Linux (GNOME / Wayland)**,
plus the fixes needed to get there and a small add-in (**ScriptBridge**) that lets
scripts be dropped into a folder and run inside Fusion automatically.

Created by **Graham** ([CharlieGraham71](https://github.com/CharlieGraham71)).

> Fusion itself is **not** in this repo (it is Autodesk's proprietary software).
> This repo holds the configuration, fixes, helper scripts and notes.

## Status (16 Nov 2026)

| Area | Status |
|---|---|
| Install (cryinkfly script) | ✅ Works |
| Sign-in (Autodesk SSO via Firefox) | ✅ Works (token cached) – see notes on Wine version |
| 3D viewport (DXVK → Vulkan, Radeon 780M) | ✅ Works on Wine 11.10 |
| UI scaling on 2560×1600 screen | ✅ 175 % (LogPixels 168) |
| Panels/popups floating over other apps | ✅ Fixed with Wine virtual desktop |
| Scripting via ScriptBridge add-in | ✅ Works (sphere, edit, STL export tested) |
| Fresh sign-in on Wine 11.10 | ⚠️ **Not tested** – see [TESTING.md](TESTING.md) |
| Fusion auto-updates | ⚠️ **Not tested** |
| Rebuild-from-scratch scripts | ⚠️ **Not run end-to-end** |

## Tested environment

| Component | Version |
|---|---|
| Machine | GPD Win Max 2 (Ryzen 7 8840U, Radeon 780M) |
| OS | Kali Linux 2026.3 (kali-rolling), kernel 6.19.14 |
| Desktop | GNOME on **Wayland** (no Xorg session available) |
| Wine | **wine-staging 11.10** (WineHQ forky repo), **held** |
| DXVK | 3.1.1 (Mesa RADV 26.1.6) |
| WebView2 | 109.0.1518.78 (148 kept as backup) |
| Fusion | 2706.1.17 |
| Installer | cryinkfly/Autodesk-Fusion-360-for-Linux |

## Layout

```
docs/TROUBLESHOOTING.md   every problem hit, root cause, fix
TESTING.md                what is verified vs. still needs testing
scripts/                  helper scripts (see header of each; review before running)
addins/ScriptBridge/      Fusion add-in: runs .py files dropped in ~/fusion-bridge/inbox
examples/                 example Fusion scripts (sphere with hole, edit, STL export)
```

## Quick start (on an existing cryinkfly install)

```bash
scripts/01-install-wine-11.10.sh     # fixes WineHQ key, installs + holds wine-staging 11.10 (sudo)
scripts/02-update-prefix.sh          # refreshes the Fusion Wine prefix for the new Wine
scripts/03-configure-prefix.sh       # DXVK overrides, 175 % scaling, virtual desktop
scripts/04-install-scriptbridge.sh   # optional: installs the ScriptBridge add-in
scripts/launch-fusion.sh             # start Fusion
```

## Using ScriptBridge

Drop a Python file into `~/fusion-bridge/inbox/`. Within ~1 s Fusion runs it, then moves it
to `~/fusion-bridge/done/` with a `.ok.log` or `.err.log` containing its output.
The script gets `adsk` and `app` (the Fusion `Application`) pre-defined.

```bash
cp examples/sphere_with_hole.py ~/fusion-bridge/inbox/
cat ~/fusion-bridge/done/*sphere_with_hole*.log
```

**Security:** anything placed in that folder runs with your user's rights inside Fusion.
Only you (and tools you run) should write to it. Disable the add-in in
*Utilities → Add-Ins → Scripts and Add-Ins* when not needed.
