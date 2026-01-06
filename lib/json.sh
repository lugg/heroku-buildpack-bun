#!/usr/bin/env bash
# JSON parsing helpers (uses bun for parsing)

read_json() {
  local file="$1"
  local key="$2"

  if [ -f "$file" ]; then
    bun -e "console.log(JSON.parse(require('fs').readFileSync('$file', 'utf8'))$key || '')" 2>/dev/null || echo ""
  else
    echo ""
  fi
}

has_script() {
  local file="$1"
  local script="$2"

  if [ -f "$file" ]; then
    bun -e "
      const pkg = JSON.parse(require('fs').readFileSync('$file', 'utf8'));
      process.exit(pkg.scripts && pkg.scripts['$script'] ? 0 : 1);
    " 2>/dev/null
    return $?
  fi
  return 1
}
