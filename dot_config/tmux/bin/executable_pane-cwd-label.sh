#!/usr/bin/env bash
set -eu

# p="${1:-}"
# home="${HOME%/}"
# p="${p%/}"

# if [[ -z "$p" || "$p" == "$home" ]]; then
#   printf '~'
# else
#   dir_name="${p##*/}"
#   printf '%s' "${dir_name^^}"
# fi
p="${1%/}"
home="${HOME%/}"

if [[ -z "$p" || "$p" == "$home" ]]; then
  printf '~'
else
  # 参照時に最長一致でパスを削り、大文字化する
  dir_name="${p##*/}"
  printf '%s' "${dir_name^^}"
fi
