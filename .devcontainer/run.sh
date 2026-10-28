#!/usr/bin/env bash
# Build the game and/or serve it with the lean4game dev server.
#   run.sh build   download the Mathlib cache and build the game
#   run.sh serve   start the game server on http://localhost:3000
#   run.sh         both
set -euo pipefail

build() {
  cd ~/game
  # Downloads occasionally fail on flaky networks; anything still missing after a retry
  # is just compiled locally by `lake build`.
  lake exe cache get || lake exe cache get || echo "WARNING: Mathlib cache incomplete, building the rest locally"
  lake build
}

serve() {
  cd ~/lean4game
  VITE_LEAN4GAME_SINGLE=true exec npm start
}

case "${1:-all}" in
  build) build ;;
  serve) serve ;;
  all) build; serve ;;
  *) echo "usage: $0 [build|serve]" >&2; exit 1 ;;
esac
