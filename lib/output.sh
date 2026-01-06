#!/usr/bin/env bash
# Output formatting helpers

header() {
  echo ""
  echo "-----> $1"
}

info() {
  echo "       $1"
}

indent() {
  sed -u 's/^/       /'
}

warn() {
  echo " !     WARNING: $1" >&2
}
