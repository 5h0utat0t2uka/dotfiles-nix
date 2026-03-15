#!/usr/bin/env bash
set -eu

p="${1%/}"
home="${HOME%/}"

if [[ -z "$p" || "$p" == "$home" ]]; then
  printf '~'
else
  dir_name="${p##*/}"
  printf '%s' "${dir_name^^}"
fi
