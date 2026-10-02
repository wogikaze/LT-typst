#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

for target in _template wasm-lt discord-bot uiua; do
  if [ -f "$target/$target.typ" ]; then
    bash scripts/build.sh "$target"
  fi
done
