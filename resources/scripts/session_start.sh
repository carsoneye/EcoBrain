#!/usr/bin/env bash
# SessionStart + PostCompact hook — injects live context

BRAIN="${CLAUDE_PROJECT_DIR:-$HOME/EcoBrain}"

echo "=== EcoBrain ==="
echo ""

if [ -f "$BRAIN/context/project.md" ]; then
  PROJECT_PATH=$(grep -oP 'Path\s*\|\s*`\K[^`]+' "$BRAIN/context/project.md" 2>/dev/null | head -1)
  LAST_ANALYZED=$(grep -oP 'Last Analyzed\s*\|\s*\K.*' "$BRAIN/context/project.md" 2>/dev/null | head -1)
  echo "Project: $PROJECT_PATH"
  echo "Last Analyzed: $LAST_ANALYZED"
  echo ""
fi

echo "--- Recommendations ---"
if [ -f "$BRAIN/recommendations/index.md" ]; then
  REC_COUNT=$(grep -cE "^\|" "$BRAIN/recommendations/index.md" 2>/dev/null)
  echo "  $REC_COUNT recommendation rows"
fi
echo ""

echo "--- Analysis Status ---"
for file in "$BRAIN"/analysis/*.md; do
  if [ -f "$file" ]; then
    name=$(basename "$file" .md)
    empty_rows=$(grep -cE "^\|\s*\|\s*\|\s*\|" "$file" 2>/dev/null)
    if [ "$empty_rows" -gt 3 ]; then
      echo "  $name: needs extraction"
    else
      echo "  $name: populated"
    fi
  fi
done
echo ""

echo "=== Ready ==="
