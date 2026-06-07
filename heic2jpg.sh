#!/bin/bash

# Directory containing heic files
DIR=$1
OUTDIR=$2
# Desired quality level (0-100)
QUALITY=100

mkdir -p $OUTDIR

# Loop through each heic file in the directory
for file in "$DIR"/*.heic; do
  # Extract the filename without the extension
  filename=$(basename "$file" .heic)
  # Convert HEIC to JPG with specified quality
  sips -s format jpeg -s formatOptions $QUALITY "$file" --out "$OUTDIR/$filename.jpg"
  # Preserve the original creation date
  creation_date=$(GetFileInfo -d "$file")
  SetFile -d "$creation_date" "$OUTDIR/$filename.jpg"
done
