#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-}"
TARGET="${TARGET%/}"

if [ -z "$TARGET" ]; then
  echo "Usage: scripts/build.sh <deck-directory>" >&2
  exit 1
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

SRC="$TARGET/$TARGET.typ"
OUT="build/$TARGET/$TARGET.pdf"

if [ ! -f "$SRC" ]; then
  echo "Source file not found: $SRC" >&2
  exit 1
fi

mkdir -p "build/$TARGET"
typst compile --root . "$SRC" "$OUT"
echo "Wrote $OUT"
