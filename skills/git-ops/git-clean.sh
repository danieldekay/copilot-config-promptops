#!/usr/bin/env bash
# Safe git clean helper (dry-run by default)
set -euo pipefail
if [ "${1-}" != "--force" ]; then
  echo "Dry run: git clean -nd && git status --porcelain"
  git clean -nd
  git status --porcelain
  exit 0
fi
# With --force, actually remove untracked files
git clean -fd
git reset --hard