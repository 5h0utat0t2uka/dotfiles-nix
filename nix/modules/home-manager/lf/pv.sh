#!/bin/sh

file="$1"
width="${2:-80}"
height="${3:-24}"

[ -f "$file" ] || exit 0

mime="$(file --mime-type -Lb -- "$file" 2>/dev/null)"

BAT="$(command -v bat 2>/dev/null || command -v batcat 2>/dev/null)"
CHAFA="$(command -v chafa 2>/dev/null)"

case "$mime" in
  image/*)
    if [ -n "$CHAFA" ]; then
      exec "$CHAFA" \
        -f symbols \
        --size="${width}x${height}" \
        --symbols=block,border,space \
        --animate=off \
        --clear \
        --polite=on \
        -- "$file"
    fi
    printf 'chafa not found\n'
    exit 0
    ;;

  text/*|application/json|application/xml|application/javascript|application/x-sh|application/x-shellscript)
    if [ -n "$BAT" ]; then
      exec "$BAT" \
        --color=always \
        --style=plain \
        --paging=never \
        --terminal-width="$width" \
        -- "$file"
    fi
    exec sed -n "1,${height}p" -- "$file"
    ;;

  *)
    exec file --brief -- "$file"
    ;;
esac
