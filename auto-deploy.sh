#!/bin/bash
# Auto-deploy: watches findersted.dk website files, commits & pushes to GitHub
# Runs as a background process.
# Usage: ./auto-deploy.sh

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR" || exit 1

fswatch -o --event Updated --event Created --event Removed \
  --exclude '.git/' \
  --exclude 'auto-deploy.sh' \
  "$DIR" |
while read -r _; do
  sleep 2
  if git status --porcelain | grep -q .; then
    echo "[$(date '+%H:%M:%S')] Changes detected — committing and pushing..."
    git add -A
    git commit -m "auto-deploy $(date '+%Y-%m-%d %H:%M')"
    git push origin main 2>&1
    echo "[$(date '+%H:%M:%S')] Deployed to findersted.dk!"
  fi
done
