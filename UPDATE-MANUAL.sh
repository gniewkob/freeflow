#!/bin/bash
# Ręczna, weryfikowana aktualizacja FreeFlow (bez wbudowanego updatera).
# Instaluje tylko, jeśli paczka jest podpisana przez The Hack Foundation (P6PV2R9443) i notaryzowana.
set -euo pipefail
TEAM="P6PV2R9443"
TAG=$(curl -fsSL https://api.github.com/repos/zachlatta/freeflow/releases/latest | /usr/bin/python3 -c 'import json,sys;print(json.load(sys.stdin)["tag_name"])')
CUR=$(defaults read /Applications/FreeFlow.app/Contents/Info CFBundleShortVersionString 2>/dev/null || echo none)
echo "Zainstalowana: $CUR | Najnowsza: $TAG"
[ "v$CUR" = "$TAG" ] && { echo "Aktualna."; exit 0; }
read -r -p "Zainstalować $TAG? [t/N] " a; [ "$a" = "t" ] || exit 0
TMP=$(mktemp -d); trap 'hdiutil detach "$TMP/mnt" -quiet 2>/dev/null || true; rm -rf "$TMP"' EXIT
curl -fsSL -o "$TMP/FreeFlow.dmg" "https://github.com/zachlatta/freeflow/releases/download/$TAG/FreeFlow.dmg"
mkdir "$TMP/mnt"; hdiutil attach -nobrowse -readonly -mountpoint "$TMP/mnt" "$TMP/FreeFlow.dmg" -quiet
APP="$TMP/mnt/FreeFlow.app"
codesign --verify --deep --strict "$APP"
codesign -dv "$APP" 2>&1 | grep -q "TeamIdentifier=$TEAM" || { echo "BŁĄD: inny wydawca"; exit 1; }
spctl -a -vv "$APP" 2>&1 | grep -q "Notarized Developer ID" || { echo "BŁĄD: brak notaryzacji"; exit 1; }
echo "Podpis i notaryzacja OK."
osascript -e 'quit app "FreeFlow"' || true; sleep 2
rm -rf /Applications/FreeFlow.app.bak; mv /Applications/FreeFlow.app /Applications/FreeFlow.app.bak
ditto "$APP" /Applications/FreeFlow.app && rm -rf /Applications/FreeFlow.app.bak
open -a /Applications/FreeFlow.app; echo "Zaktualizowano do $TAG (ustawienia zachowane)."
