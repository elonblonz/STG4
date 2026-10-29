#!/usr/bin/env bash
# Build the game and/or serve it with the lean4game dev server.
#   run.sh build   download the Mathlib cache and build the game
#   run.sh serve   start the game server on http://localhost:3000
#   run.sh         both
set -euo pipefail

build() {
  cd ~/game
  # Only download the Mathlib modules the game imports (and what they import), not all of
  # Mathlib: about 1 GB instead of 6. With no Mathlib imports this downloads everything.
  local modules
  modules=$(grep -rhoE '^import Mathlib[A-Za-z0-9_.]*' Game Game.lean | cut -d' ' -f2 | sort -u)
  # Downloads occasionally fail on flaky networks; anything still missing after a retry
  # is just compiled locally by `lake build`.
  # shellcheck disable=SC2086
  lake exe cache get $modules || lake exe cache get $modules || echo "WARNING: Mathlib cache incomplete, building the rest locally"
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
