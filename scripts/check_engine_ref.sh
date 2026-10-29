#!/usr/bin/env bash
# Check that the game and its dev container use the same lean4game release:
# `gameServerRelease` in lakefile.lean (the Lean GameServer the levels are compiled against),
# `lake-manifest.json`, and `LEAN4GAME_REF` in .devcontainer/Dockerfile and docker-compose.yml
# (the web client and relay).
set -euo pipefail
cd "$(dirname "$0")/.."

lakefile=$(sed -nE 's/^def gameServerRelease : String := "([^"]+)".*/\1/p' lakefile.lean)
dockerfile=$(sed -nE 's/^ARG LEAN4GAME_REF=([^[:space:]]+).*/\1/p' .devcontainer/Dockerfile)
compose=$(sed -nE 's/.*LEAN4GAME_REF: \$\{LEAN4GAME_REF:?-([^}]+)\}.*/\1/p' .devcontainer/docker-compose.yml)
manifest=$(python3 -c 'import json; print(next(p["inputRev"] for p in json.load(open("lake-manifest.json"))["packages"] if p["name"] == "GameServer"))')

echo "lakefile.lean:      $lakefile"
echo "lake-manifest.json: $manifest"
echo "Dockerfile:         $dockerfile"
echo "docker-compose.yml: $compose"
if [[ -n "$lakefile" && "$lakefile" == "$dockerfile" && "$lakefile" == "$compose" && "$lakefile" == "$manifest" ]]; then
  echo "OK: all use $lakefile"
else
  echo "ERROR: lean4game release differs; update them together (and run \`lake update GameServer\`)" >&2
  exit 1
fi
