#!/usr/bin/env bash
set -u

dir="${1:-}"

cd "$dir" 2>/dev/null || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

branch="$(git symbolic-ref --quiet --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null || true)"
[[ -n "$branch" ]] || exit 0

upper_branch="$(printf '%s' "$branch" | tr '[:lower:]' '[:upper:]')"
printf '[%s]' "$upper_branch"
