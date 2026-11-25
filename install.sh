#!/bin/bash
# NotchIsland installer: downloads the latest release and puts it in /Applications.
# Files fetched with curl don't get the quarantine flag, so macOS doesn't block the first launch.
set -euo pipefail
URL="https://github.com/NorthlightApps/notchisland/releases/latest/download/NotchIsland.dmg"
TMP="$(mktemp -d)"
trap 'hdiutil detach "$TMP/mnt" -quiet 2>/dev/null || true; rm -rf "$TMP"' EXIT
echo "⬇️  Скачиваю NotchIsland…"
curl -fL --progress-bar -o "$TMP/NotchIsland.dmg" "$URL"
hdiutil attach -nobrowse -readonly -mountpoint "$TMP/mnt" "$TMP/NotchIsland.dmg" >/dev/null
pkill -x NotchIsland 2>/dev/null || true
sleep 1
DEST="/Applications/NotchIsland.app"
if [ -w /Applications ]; then rm -rf "$DEST"; ditto "$TMP/mnt/NotchIsland.app" "$DEST"
else sudo rm -rf "$DEST"; sudo ditto "$TMP/mnt/NotchIsland.app" "$DEST"; fi
xattr -dr com.apple.quarantine "$DEST" 2>/dev/null || true
open "$DEST"
echo "✅ Готово! NotchIsland в «Программах» и уже запущен — значок капсулы в строке меню."
