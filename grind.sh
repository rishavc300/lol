#!/bin/bash
set -e
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SITE_DIR="${SITE_DIR:-$REPO_DIR}"
cd "$REPO_DIR"
git pull --rebase --quiet 2>/dev/null || git pull --quiet
CURRENT=$(grep -oE 'id="number">[0-9]+' index.html | grep -oE '[0-9]+' | head -1)
NEXT=$((CURRENT + 1))
sed -i '' "s|<span id=\"number\">$CURRENT</span>|<span id=\"number\">$NEXT</span>|g" index.html
sed -i '' "s|TOTAL COMMITS: <span id=\"commits\">$CURRENT</span>|TOTAL COMMITS: <span id=\"commits\">$NEXT</span>|g" index.html
sed -i '' "s|THE NUMBER IS NOW <span id=\"last-num\">$CURRENT</span>|THE NUMBER IS NOW <span id=\"last-num\">$NEXT</span>|g" index.html
[ "$SITE_DIR" != "$REPO_DIR" ] && cp index.html "$SITE_DIR/index.html"
git add -A
git commit -m "🔥 THE NUMBER IS NOW $NEXT" --quiet
git push --quiet
echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] ✅ $CURRENT → $NEXT"
