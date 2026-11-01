#!/bin/bash
# Zapisuje decyzję dla commita z upstream. accept = cherry-pick na local/main; reject = tylko wpis w dzienniku.
set -euo pipefail
cd "$(dirname "$0")"
sha=$(git rev-parse --verify "$1^{commit}"); action=$2; reason=${3:-}
[ "$(git branch --show-current)" = "local/main" ] || { echo "Przełącz się na local/main"; exit 1; }
git diff --quiet && git diff --cached --quiet || { echo "Masz niezatwierdzone zmiany w śledzonych plikach"; exit 1; }
subj=$(git log -1 --format=%s "$sha")
case $action in
  accept) git cherry-pick -x "$sha" ;;
  reject) ;;
  *) echo "accept|reject"; exit 1 ;;
esac
printf '| %s | %s | %s | %s | %s |\n' "${sha:0:9}" "$(date +%F)" "$action" "${subj//|/-}" "${reason//|/-}" >> UPSTREAM-DECISIONS.md
git add UPSTREAM-DECISIONS.md && git commit -q -m "upstream review: $action ${sha:0:9}" && echo "Zapisano: $action ${sha:0:9}"
