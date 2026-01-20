#!/usr/bin/env bash
dir="$1"
cd "$dir" 2>/dev/null || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

repo_dir_name="$(basename -- "$dir")"

branch="$(git branch --show-current 2>/dev/null)"
if [ -z "$branch" ] || [ "$branch" = "HEAD" ]; then
  branch="$(git rev-parse --short HEAD 2>/dev/null || echo "")"
fi
[ -z "$branch" ] && exit 0
upper_branch="$(printf '%s' "$branch" | tr '[:lower:]' '[:upper:]')"

# tmux.conf で定義した環境変数を取得（例: nord9="#81A1C1"）
nord9="$(tmux show-environment -g nord9 2>/dev/null | sed 's/^nord9=//')"
nord2="$(tmux show-environment -g nord2 2>/dev/null | sed 's/^nord2=//')"
nord3="$(tmux show-environment -g nord3 2>/dev/null | sed 's/^nord3=//')"
nord0="$(tmux show-environment -g nord0 2>/dev/null | sed 's/^nord0=//')"

# printf '#[fg=%s,bg=%s]%s %s#[default]' "$nord0" "$nord2" " DEVBOX"
# printf ' #[fg=%s,bg=%s]%s %s#[default]' "$nord0" "$nord2" " $upper_branch"
printf '#[fg=%s,bg=%s]%s %s#[default]' "$nord0" "$nord3" " DEVBOX"
printf '#[fg=%s,bg=%s]%s %s#[default]' "$nord0" "$nord9" " $upper_branch"
# printf '%s#[default]' " 󰊢 $branch"
# printf '#[fg=%s,bg=%s]%s %s#[default]' "$nord9" "$nord1" " $repo_dir_name" "[$branch] "
