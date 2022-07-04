#!/bin/sh

AUTHOR_FIRST=$1
AUTHOR_LAST=$2
FILENAME=$(echo "$AUTHOR_LAST" | tr '[:upper:]' '[:lower:]')
# FOLDER=$1
FOLDER="united-states"
#DENONYM=$2
DENONYM="American"

mkdir -p "$FOLDER"
touch "$FOLDER/$FILENAME.md"

echo "---\ntitle: $AUTHOR_FIRST $AUTHOR_LAST\n---\n\nAn [$DENONYM](../index.html) author.\n\n" > "$FOLDER/$FILENAME.md"
echo "- [$AUTHOR_FIRST $AUTHOR_LAST]($FILENAME/index.html)" >> "$FOLDER.md"
codium "$FOLDER/$FILENAME.md"