# Troubleshooting log – what broke, why, and the fix

All found on 16 Nov 2026 on the environment in the README.

## 1. Clicking "Sign In" does nothing (no browser opens)

- **Symptom:** "Check your web browser to sign in", Firefox never opens.
- **Evidence:** `IdServices.log` shows `LaunchNativeBrowser` then, ~12 s later,
  `SSO process quit or crashed`. With `WINEDEBUG=+seh` the crash is an access violation
  inside Wine's `shell32.dll` with registers full of UTF-16 text from the login URL,
  then `c0000409` (stack buffer overrun). `wine winebrowser https://example.com`
  worked fine, so it is the *long* URL that crashes shell32.
- **Cause:** bug in Wine 10.0 (Kali package `wine 10.0~repack-11`).
- **Fix:** install WineHQ **wine-staging** (11.22 fixed it). See issue 5 for why we then
  pinned 11.10.

## 2. `apt update`: WineHQ repo "not signed" / NO_PUBKEY 76F1A20FF987672F

- **Cause:** `/etc/apt/keyrings/winehq-archive.key` was ASCII-armoured; newer apt only
  accepts armoured keys with a `.asc` extension.
- **Fix:**
  ```bash
  curl -fsSL https://dl.winehq.org/wine-builds/winehq.key \
    | sudo gpg --dearmor --yes -o /etc/apt/keyrings/winehq-archive.key
  ```

## 3. After upgrading Wine, Fusion won't start

- **Symptom:** `unimplemented function ADVAPI32.dll.SystemFunction036`,
  `Qt6Core.dll failed to initialize`.
- **Cause:** the cryinkfly installer writes `disable` to `<prefix>/.update-timestamp`,
  so Wine never refreshes the prefix's system DLLs (e.g. new `cryptbase.dll`).
- **Fix:** `rm .update-timestamp; wine wineboot -u`, then write `disable` back.
  During the update a ".NET – This application could not be started" box appears
  (wine-mono step clashing with native .NET). It is harmless: close it / kill the
  `rundll32.exe setupapi,InstallHinfSection` process. Do **not** run Microsoft's .NET
  Repair Tool.

## 4. 3D viewport white / empty

- **Cause:** prefix DLL overrides had `d3d11`, `dxgi`, `d3d10core`, `d3d9` = `builtin`,
  so Wine's own wined3d was used instead of the installed DXVK DLLs.
- **Fix:** set those overrides to `native` (`scripts/03-configure-prefix.sh`).
  DXVK log then shows `Found device: AMD Radeon 780M Graphics (RADV PHOENIX)`.

## 5. Viewport black background, frames smear when orbiting

- **Cause:** Wine regression from **11.11** – WineHQ bug 60010
  ("Autodesk Fusion: 3D canvas renders black on Wine 11.11 and above").
  Reporter: 11.10 is the last good version.
- **Fix:** downgrade and hold:
  ```bash
  sudo apt install --allow-downgrades winehq-staging=11.10~forky-1 wine-staging=11.10~forky-1
  sudo apt-mark hold winehq-staging wine-staging
  ```
  then re-run the prefix update (issue 3).

## 6. UI text tiny

- **Cause:** Wine default 96 DPI on a 2560×1600 10" panel.
- **Fix:** `LogPixels = 168` (175 %) in HKCU\Control Panel\Desktop and the Fonts key.

## 7. Fusion panels / "Unsaved" banner float over other apps

- **Cause:** Fusion's Qt tool windows become separate always-on-top X windows under
  Xwayland.
- **Fix:** Wine virtual desktop:
  `HKCU\Software\Wine\Explorer\Desktop = Default`,
  `HKCU\Software\Wine\Explorer\Desktops\Default = 2560x1520`.

## 8. "Unable to sign in – system settings, firewall or antivirus…"

- **Seen once** after a hard restart. Log: `Timed out after 15s while waiting for SSO
  process to be ready` (two AdskIdentityManager processes racing).
- **Fix:** `wineserver -k`, relaunch. Signed in fine afterwards.

## 9. Remote control with xdotool doesn't work

- GNOME Wayland (Kali 2026.3 ships no Xorg session) does not deliver XTEST input to
  Xwayland windows. Screenshots of the Wine window via `import -window` do work.
- **Workaround:** ScriptBridge add-in (scripts dropped into a folder run inside Fusion).

## Useful log locations (inside the prefix)

```
drive_c/users/$USER/AppData/Local/Autodesk/Identity Services/Log/IdServices.log   sign-in
drive_c/users/$USER/AppData/Local/Autodesk/CER/                                  crash reports
DXVK: launch with DXVK_LOG_LEVEL=info DXVK_LOG_PATH=/tmp/dxvklog
```
