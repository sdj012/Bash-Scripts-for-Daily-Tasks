#!/bin/bash

# Create the destination folder if it doesn't exist
DEST="ImportedMovies"
mkdir -p "$DEST"

# Find all .mov files and copy them to ImportedMovies
COUNT=0
while IFS= read -r -d '' file; do
    filename=$(basename "$file")

    # Handle duplicate filenames by appending a counter
    if [[ -e "$DEST/$filename" ]]; then
        base="${filename%.*}"
        ext="${filename##*.}"
        counter=1
        while [[ -e "$DEST/${base}_${counter}.${ext}" ]]; do
            ((counter++))
        done
        filename="${base}_${counter}.${ext}"
    fi

    mv "$file" "$DEST/$filename"
    echo "Moved: $file → $DEST/$filename"
    ((COUNT++))
done < <(find . -iname "*.mov" -not -path "./$DEST/*" -print0)

echo ""
echo "Done! $COUNT .mov file(s) copied to '$DEST'."
