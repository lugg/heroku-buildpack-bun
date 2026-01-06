#!/usr/bin/env bash
# Error handling helpers

fail() {
  echo ""
  echo " !     ERROR: $1" >&2
  echo ""
  exit 1
}

fail_install() {
  fail "Failed to install dependencies. Check your bun.lock file is up to date."
}

fail_build() {
  fail "Build script failed. Check your build output above for errors."
}
