#!/bin/sh

file="$1"
width="${2:-80}"
height="${3:-24}"
mode="${6:-preview}"

[ -f "$file" ] || exit 0

mime="$(file --mime-type -Lb -- "$file" 2>/dev/null)"

BAT="$(command -v bat 2>/dev/null || command -v batcat 2>/dev/null)"
CHAFA="$(command -v chafa 2>/dev/null)"

case "$mime" in
  image/*)
    if [ -n "$CHAFA" ]; then
      # tmux 越しでも安定しやすい文字ベース出力
      exec "$CHAFA" \
        --size="${width}x${height}" \
        --symbols=block,border,space \
        --animate=off \
        --clear \
        --polite=on \
        -- "$file" || true
    fi

    printf 'No previewer for image: chafa not found\n'
    exit 0
    ;;

  text/*|*/json|*/xml|*/javascript|*/x-shellscript)
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
    # bat があれば一応それで試す。ダメなら file 情報だけ表示
    if [ -n "$BAT" ]; then
      exec "$BAT" \
        --color=always \
        --style=plain \
        --paging=never \
        --terminal-width="$width" \
        -- "$file" 2>/dev/null || file --brief -- "$file"
    fi

    exec file --brief -- "$file"
    ;;
esac
