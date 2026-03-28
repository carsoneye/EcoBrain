#!/usr/bin/env bash
# Verify orphan notes — files not linked from any other note

links=$(grep -hro "\[\[[^]|]*" . --include="*.md" --exclude-dir=".git" --exclude-dir=".claude" | sed 's/\[\[//' | sort | uniq)

for file in $(find . -type f -name "*.md" ! -path "*/.git/*" ! -path "*/.claude/*" ! -path "*/node_modules/*" ! -path "./CLAUDE.md"); do
  basename_no_ext=$(basename "$file" .md)
  path_no_ext=${file#./}
  path_no_ext=${path_no_ext%.md}

  is_orphan=1
  for link in $links; do
    if [ "$link" = "$basename_no_ext" ] || [ "$link" = "$path_no_ext" ]; then
      is_orphan=0
      break
    fi
  done

  if [ $is_orphan -eq 1 ]; then
    echo "$file"
  fi
done
