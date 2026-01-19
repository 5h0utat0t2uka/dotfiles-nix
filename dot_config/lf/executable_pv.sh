#!/bin/sh
# lf previewer: $1=file, $2=width, $3=height, ... $6=mode :contentReference[oaicite:1]{index=1}

file="$1"
width="${2:-80}"

[ -f "$file" ] || exit 0

# bat が無い環境向けに batcat もフォールバック
BAT="$(command -v bat 2>/dev/null || command -v batcat 2>/dev/null)"
[ -n "$BAT" ] || exit 0

exec "$BAT" --color=always --paging=never --terminal-width="$width" -- "$file"
