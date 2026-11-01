#!/bin/bash
# Przegląd nowych zmian w oficjalnym FreeFlow (upstream) względem Twojej gałęzi local/main.
# Niczego nie scala. Pokazuje commity, których jeszcze nie oceniłeś, z flagami ryzyka.
# Użycie: ./UPSTREAM-REVIEW.sh [-v]   (-v = pokaż pełny diff flagowanych zmian)
set -euo pipefail
cd "$(dirname "$0")"
git fetch -q upstream --tags
LOG=UPSTREAM-DECISIONS.md
SENSITIVE='Sources/UpdateManager.swift|Sources/KeychainStorage.swift|Sources/AppContextService.swift|Sources/LLMAPITransport.swift|Sources/TranscriptionService.swift|Sources/RealtimeTranscriptionService.swift|Sources/PostProcessingService.swift|FreeFlow.entitlements|Info.plist|Makefile|\.github/workflows/'
echo "Twoja wersja: $(git describe --tags --always local/main) | Oficjalna: $(git describe --tags --always upstream/main)"
echo
n=0
for c in $(git rev-list --reverse --no-merges local/main..upstream/main); do
  grep -q "^| ${c:0:9} " "$LOG" 2>/dev/null && continue   # już oceniony
  n=$((n+1))
  files=$(git diff-tree --no-commit-id --name-only -r "$c")
  flags=""
  echo "$files" | grep -qE "$SENSITIVE" && flags+=" [WRAŻLIWE PLIKI]"
  d=$(git show "$c" --format= -U0)
  echo "$d" | grep -E '^\+' | grep -qE 'https?://' && flags+=" [NOWY ADRES URL]"
  echo "$d" | grep -E '^\+' | grep -qE 'Process\(\)|NSTask|/bin/(ba|z)?sh|osascript|dlopen' && flags+=" [URUCHAMIANIE PROCESÓW]"
  echo "$d" | grep -E '^\+' | grep -qiE 'analytics|telemetry|sentry|posthog|mixpanel' && flags+=" [TELEMETRIA?]"
  echo "$d" | grep -E '^\+' | grep -qE 'base64Encoded|NSPasteboard' && flags+=" [SCHOWEK/BASE64]"
  printf '%s  %s  %s%s\n' "${c:0:9}" "$(git log -1 --format='%ad' --date=short "$c")" "$(git log -1 --format='%s' "$c")" "$flags"
  git diff-tree --no-commit-id --stat=100 -r "$c" | tail -1 | sed 's/^/           /'
  if [ "${1:-}" = "-v" ] && [ -n "$flags" ]; then git show "$c" --format= --stat -p | sed 's/^/    /'; fi
done
echo
[ $n -eq 0 ] && echo "Brak nowych, nieocenionych zmian." || echo "Nieocenione: $n. Decyzje: ./UPSTREAM-DECIDE.sh <sha> accept|reject \"powód\""
