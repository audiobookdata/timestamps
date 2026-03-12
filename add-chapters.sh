#!/bin/bash

AUDIO_FILE="$1"
CHAPTER_FILE="$2"
OUTPUT_FILE="${AUDIO_FILE%.*}-chapterized.m4b"
TEMP_META="temp_meta.txt"

if [ -z "$AUDIO_FILE" ] || [ -z "$CHAPTER_FILE" ]; then
    echo "Usage: ./merge_chapters.sh <audiobook.m4b> <repo_chapters.txt>"
    exit 1
fi

ffmpeg -i "$AUDIO_FILE" -f ffmetadata "$TEMP_META" -y -loglevel error
sed -i.bak '/\[CHAPTER\]/,$d' "$TEMP_META"
cat "$CHAPTER_FILE" >> "$TEMP_META"
ffmpeg -i "$AUDIO_FILE" -f ffmetadata -i "$TEMP_META" \
       -map 0 -map_metadata 1 -codec copy "$OUTPUT_FILE" -loglevel warning

rm "$TEMP_META" "${TEMP_META}.bak"
