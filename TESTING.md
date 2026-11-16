# Testing status

Legend: ✅ verified · ⚠️ needs testing · ❌ known broken

## Verified (16 Nov 2026)

- ✅ Fusion starts and stays signed in (cached token) on wine-staging 11.10
- ✅ 3D viewport renders correctly with DXVK 3.1.1 on Radeon 780M (box + sphere checked)
- ✅ UI scaling 175 % (LogPixels = 168)
- ✅ Wine virtual desktop keeps Browser/Comments panels and "Unsaved" banner inside Fusion
- ✅ ScriptBridge add-in loads on startup and runs scripts from the inbox
- ✅ Example: 50 mm sphere with through-hole created, hole edited 10 → 28 mm, STL exported
  (binary, 6318 triangles, bbox 49.98 × 49.95 × 41.42 mm – correct for the truncation by the hole)

## Needs testing

- ⚠️ **Fresh sign-in on Wine 11.10.** The SSO crash (Wine shell32 overflow on the long
  login URL) was fixed by Wine 11.22 and sign-in was done on 11.22. Wine was then rolled
  back to 11.10 for the viewport bug. If the token expires / you sign out, test whether
  sign-in still works on 11.10. Fallback: temporarily switch to 11.22, sign in, switch back.
- ⚠️ **Fusion auto-update** (new webdeploy folder). Launcher picks newest Fusion360.exe;
  check DXVK, WebView2 109 swap and patched Qt6WebEngineCore.dll survive an update.
- ⚠️ **Scripts in `scripts/` run end-to-end on a clean machine** – written from the
  manual steps taken on 16 Nov; not yet run start to finish.
- ⚠️ **Saving to Autodesk cloud** (Save dialog appeared; save not completed during testing).
- ⚠️ **Virtual-desktop size** after display/scale changes (fixed at 2560×1520).
- ⚠️ **Long sessions / sleep-resume** stability.
- ⚠️ **Newer Wine (> 11.22)**: check whether WineHQ bug 60010 (black/smeared viewport
  from 11.11) is fixed, then unhold and upgrade.
- ⚠️ **SSO startup timeout** ("Unable to sign in" after 15 s) seen once after a hard
  restart; a clean relaunch fixed it. Watch for repeats.

## Known broken / limitations

- ❌ Wine 10.0 (Kali package): sign-in helper crashes – do not use.
- ❌ Wine 11.11 – 11.22: viewport black / not cleared (smeared frames).
- ❌ xdotool input on GNOME Wayland does not reach Wine windows; use ScriptBridge instead.
- ❌ winetricks/ollydbg/sqldict were removed when Kali's `wine` package was replaced.
