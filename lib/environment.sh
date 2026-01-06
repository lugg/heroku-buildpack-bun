#!/usr/bin/env bash
# Environment variable helpers

export_env_dir() {
  local env_dir="$1"
  local denylist="^(PATH|GIT_DIR|CPATH|CPPATH|LD_PRELOAD|LIBRARY_PATH)$"

  if [ -d "$env_dir" ]; then
    for e in $(ls "$env_dir"); do
      if ! echo "$e" | grep -qE "$denylist"; then
        export "$e=$(cat "$env_dir/$e")"
      fi
    done
  fi
}
