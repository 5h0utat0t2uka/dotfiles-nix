#!/usr/bin/env bash

dir="$1"
cd "$dir" 2>/dev/null || exit 0
# git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
# repo_dir_name="$(basename -- "$dir")"
# branch="$(git branch --show-current 2>/dev/null)"
# if [ -z "$branch" ] || [ "$branch" = "HEAD" ]; then
#   branch="$(git rev-parse --short HEAD 2>/dev/null || echo "")"
# fi
# [ -z "$branch" ] && exit 0
# upper_branch="$(printf '%s' "$branch" | tr '[:lower:]' '[:upper:]')"

# nord9="$(tmux show-environment -g nord9 2>/dev/null | sed 's/^nord9=//')"
# nord2="$(tmux show-environment -g nord2 2>/dev/null | sed 's/^nord2=//')"
# nord3="$(tmux show-environment -g nord3 2>/dev/null | sed 's/^nord3=//')"
# nord0="$(tmux show-environment -g nord0 2>/dev/null | sed 's/^nord0=//')"
# nord10="$(tmux show-environment -g nord10 2>/dev/null | sed 's/^nord10=//')"

# DEVBOX_STATUS="$(tmux show-environment -g DEVBOX_SHELL_ENABLED 2>/dev/null | sed 's/^DEVBOX_SHELL_ENABLED=//')"
# if [ "$DEVBOX_STATUS" = "1" ]; then
#   printf '#[fg=%s,bg=%s,bold]%s %s#[default]' "$nord0" "$nord3" " DEVBOX"
# fi
# printf '#[fg=%s,bg=%s,bold]%s %s#[default]' "$nord0" "$nord10" " $upper_branch"


# tmux.conf で定義したカラースキーマ
nord3="$(tmux show-environment -g nord3 2>/dev/null | sed 's/^nord3=//')"
nord0="$(tmux show-environment -g nord0 2>/dev/null | sed 's/^nord0=//')"
nord10="$(tmux show-environment -g nord10 2>/dev/null | sed 's/^nord10=//')"

# devbox環境変数をチェック（git に関係なく表示）
DEVBOX_STATUS="$(tmux show-environment -g DEVBOX_SHELL_ENABLED 2>/dev/null | sed 's/^DEVBOX_SHELL_ENABLED=//')"
if [ "$DEVBOX_STATUS" = "1" ]; then
  printf '#[fg=%s,bg=%s,bold]%s #[default]' "$nord0" "$nord3" " DEVBOX"
fi

# git チェック（git 管理下のみブランチ表示）
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch="$(git branch --show-current 2>/dev/null)"
  if [ -z "$branch" ] || [ "$branch" = "HEAD" ]; then
    branch="$(git rev-parse --short HEAD 2>/dev/null || echo "")"
  fi
  if [ -n "$branch" ]; then
    upper_branch="$(printf '%s' "$branch" | tr '[:lower:]' '[:upper:]')"
    printf '#[fg=%s,bg=%s,bold]%s #[default]' "$nord0" "$nord10" " $upper_branch"
  fi
fi
