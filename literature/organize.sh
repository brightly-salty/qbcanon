#!/bin/sh

AUTHOR_FIRST=$3
AUTHOR_LAST=$4
FILENAME=$(echo "$AUTHOR_LAST" | tr '[:upper:]' '[:lower:]')
FOLDER=$1
DENONYM=$2

mkdir -p "$FOLDER"
touch "$FOLDER/$FILENAME.md"

echo "---\ntitle: $AUTHOR_FIRST $AUTHOR_LAST\n---\n\nA [$DENONYM](../index.html) author.\n\n" > "$FOLDER/$FILENAME.md"
echo "- [$AUTHOR_FIRST $AUTHOR_LAST]($FILENAME/index.html)" >> "$FOLDER.md"
codium "$FOLDER/$FILENAME.md"