#!/usr/bin/env bash
# SessionStart + PostCompact hook — injects live context

BRAIN="${CLAUDE_PROJECT_DIR:-$HOME/EcoBrain}"

echo "=== EcoBrain ==="
echo ""

# Show all tracked projects
for project_dir in "$BRAIN"/projects/*/; do
  [ -d "$project_dir" ] || continue
  name=$(basename "$project_dir")
  project_file="$project_dir/context/project.md"

  if [ -f "$project_file" ]; then
    PROJECT_PATH=$(grep -oP 'Path\s*\|\s*`\K[^`]+' "$project_file" 2>/dev/null | head -1)
    LAST_ANALYZED=$(grep -oP 'Last Analyzed\s*\|\s*\K\S+' "$project_file" 2>/dev/null | head -1)
    echo "Project: $name"
    echo "  Path: ${PROJECT_PATH:-not set}"
    echo "  Last Analyzed: ${LAST_ANALYZED:-never}"

    # Count recommendations
    rec_file="$project_dir/decisions/recommendations.md"
    if [ -f "$rec_file" ]; then
      OPEN=$(grep -cE "^\|.*\[ \]" "$rec_file" 2>/dev/null)
      echo "  Open Recommendations: ${OPEN:-0}"
    fi

    # Analysis status
    for file in "$project_dir"/analysis/*.md "$project_dir"/context/*.md; do
      [ -f "$file" ] || continue
      fname=$(basename "$file" .md)
      dir=$(basename "$(dirname "$file")")
      empty=$(grep -cE '^\|\s+\|' "$file" 2>/dev/null)
      total=$(grep -cE '^\|' "$file" 2>/dev/null)
      if [ "$empty" -gt 5 ]; then
        echo "  $dir/$fname: needs extraction"
      elif [ "$total" -gt 0 ]; then
        echo "  $dir/$fname: populated (${total} rows)"
      fi
    done
    echo ""
  fi
done

# Global knowledge status
echo "--- Global Knowledge ---"
failures=$(find "$BRAIN/_global/failures" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
verified=$(find "$BRAIN/_global/verified-as-of" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
echo "  Failures library: $failures files"
echo "  Verified-as-of: $verified entries"

# Check for stale verified-as-of entries (>90 days)
today=$(date +%s)
for vfile in "$BRAIN"/_global/verified-as-of/*.md; do
  [ -f "$vfile" ] || continue
  reverify=$(grep -oP 're-verify-after:\s*\K\S+' "$vfile" 2>/dev/null)
  if [ -n "$reverify" ]; then
    reverify_ts=$(date -j -f "%Y-%m-%d" "$reverify" +%s 2>/dev/null || date -d "$reverify" +%s 2>/dev/null)
    if [ -n "$reverify_ts" ] && [ "$today" -gt "$reverify_ts" ]; then
      echo "  STALE: $(basename "$vfile" .md) — re-verify overdue"
    fi
  fi
done

echo ""
echo "=== Ready ==="
