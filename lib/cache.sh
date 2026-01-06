#!/usr/bin/env bash
# Cache helpers

restore_cache() {
  local cache_dir="$1"
  local build_dir="$2"

  if [ -d "$cache_dir/node_modules" ]; then
    cp -r "$cache_dir/node_modules" "$build_dir/"
  fi
}

save_cache() {
  local cache_dir="$1"
  local build_dir="$2"

  mkdir -p "$cache_dir"

  if [ -d "$build_dir/node_modules" ]; then
    cp -r "$build_dir/node_modules" "$cache_dir/"
  fi
}

clear_cache() {
  local cache_dir="$1"
  rm -rf "$cache_dir"/*
}
