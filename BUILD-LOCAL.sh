#!/bin/bash
# Buduje, testuje, podpisuje lokalnym certyfikatem i instaluje "FreeFlow Dev" z gałęzi local/main.
set -euo pipefail
cd "$(dirname "$0")"
export DEVELOPER_DIR="${DEVELOPER_DIR:-$(ls -d /Applications/Xcode*.app 2>/dev/null | sort -V | tail -1)/Contents/Developer}"
ID=$(security find-identity -p codesigning | awk '/FreeFlow Local Signing/ {print $2; exit}')
[ -n "$ID" ] || { echo "Brak certyfikatu 'FreeFlow Local Signing'"; exit 1; }
[ "$(git branch --show-current)" = "local/main" ] || { echo "Przełącz się na local/main"; exit 1; }
make test
make all CODESIGN_IDENTITY="$ID"
codesign --verify --strict "build/FreeFlow Dev.app"
osascript -e 'quit app "FreeFlow Dev"' 2>/dev/null || true; sleep 2
rm -rf "/Applications/FreeFlow Dev.app.bak"
[ -d "/Applications/FreeFlow Dev.app" ] && mv "/Applications/FreeFlow Dev.app" "/Applications/FreeFlow Dev.app.bak"
ditto "build/FreeFlow Dev.app" "/Applications/FreeFlow Dev.app" && rm -rf "/Applications/FreeFlow Dev.app.bak"
open "/Applications/FreeFlow Dev.app"
echo "Zainstalowano FreeFlow Dev z $(git describe --always --dirty)"
