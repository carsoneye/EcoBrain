#!/usr/bin/env bash
# Quick codebase stats — run from inside the target project

if [ -z "$1" ]; then
  echo "Usage: extract-stats.sh /path/to/codebase"
  exit 1
fi

TARGET="$1"

echo "=== Codebase Stats ==="
echo ""

echo "Languages:"
find "$TARGET" -type f \
  ! -path "*/node_modules/*" ! -path "*/.git/*" ! -path "*/dist/*" \
  ! -path "*/build/*" ! -path "*/vendor/*" ! -path "*/.next/*" \
  ! -path "*/__pycache__/*" ! -path "*/.cache/*" \
  2>/dev/null | sed 's/.*\.//' | sort | uniq -c | sort -rn | head -10
echo ""

echo "Total Files:"
find "$TARGET" -type f \
  ! -path "*/node_modules/*" ! -path "*/.git/*" ! -path "*/dist/*" \
  ! -path "*/build/*" ! -path "*/vendor/*" ! -path "*/.next/*" \
  ! -path "*/__pycache__/*" ! -path "*/.cache/*" \
  2>/dev/null | wc -l
echo ""

echo "Directory Structure (2 levels):"
find "$TARGET" -maxdepth 2 -type d \
  ! -path "*/node_modules/*" ! -path "*/.git/*" ! -path "*/dist/*" \
  ! -path "*/build/*" ! -path "*/vendor/*" ! -path "*/.next/*" \
  ! -path "*/__pycache__/*" ! -path "*/.cache/*" \
  2>/dev/null | head -30
