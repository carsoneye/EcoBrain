#!/usr/bin/env bash
# SessionStart + PostCompact hook — injects live context

BRAIN="${CLAUDE_PROJECT_DIR:-$HOME/EcoBrain}"

echo "=== EcoBrain ==="
echo ""

if [ -f "$BRAIN/context/project.md" ]; then
  PROJECT_PATH=$(grep -oP 'Path\s*\|\s*`\K[^`]+' "$BRAIN/context/project.md" 2>/dev/null | head -1)
  LAST_ANALYZED=$(grep -oP 'Last Analyzed\s*\|\s*\K\S+' "$BRAIN/context/project.md" 2>/dev/null | head -1)
  echo "Project: ${PROJECT_PATH:-not set}"
  echo "Last Analyzed: ${LAST_ANALYZED:-never}"
  echo ""
fi

echo "--- Recommendations ---"
if [ -f "$BRAIN/recommendations/index.md" ]; then
  OPEN=$(grep -cE "^\|.*\|" "$BRAIN/recommendations/index.md" 2>/dev/null | head -1)
  echo "  ${OPEN:-0} recommendation rows"
fi
echo ""

echo "--- Analysis Status ---"
for file in "$BRAIN"/analysis/*.md "$BRAIN"/architecture/*.md "$BRAIN"/context/*.md; do
  if [ -f "$file" ]; then
    name=$(basename "$file" .md)
    dir=$(basename "$(dirname "$file")")
    # Count empty table cells — a populated row has content between pipes
    empty=$(grep -cE '^\|\s+\|' "$file" 2>/dev/null)
    total=$(grep -cE '^\|' "$file" 2>/dev/null)
    if [ "$empty" -gt 5 ]; then
      echo "  $dir/$name: needs extraction"
    else
      echo "  $dir/$name: populated (${total} rows)"
    fi
  fi
done
echo ""

echo "=== Ready ==="
