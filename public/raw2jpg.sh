#!/bin/bash
set -euo pipefail

DIR="${1:-}"
OUTDIR="${2:-}"
QUALITY=100

[[ -d "$DIR" ]] || { echo "Input dir invalid: $DIR"; exit 1; }
[[ -n "$OUTDIR" ]] || { echo "Usage: $0 <input_dir> <output_dir>"; exit 1; }

mkdir -p "$OUTDIR"
shopt -s nullglob

for file in "$DIR"/*.ARW "$DIR"/*.arw; do
  filename=$(basename "$file")
  filename="${filename%.*}"

  sips -s format jpeg -s formatOptions "$QUALITY" "$file" --out "$OUTDIR/$filename.jpg"

  if command -v GetFileInfo >/dev/null 2>&1 && command -v SetFile >/dev/null 2>&1; then
    creation_date=$(GetFileInfo -d "$file" 2>/dev/null || true)
    [[ -n "${creation_date:-}" ]] && SetFile -d "$creation_date" "$OUTDIR/$filename.jpg" || true
  fi
done
