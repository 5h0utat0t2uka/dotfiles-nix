#!/bin/sh
set -eu

if [ "${DOTFILES_NIX_ENABLE_DARWIN:-}" != "1" ]; then
  echo "nix-darwin is disabled."
  echo "Run with: DOTFILES_NIX_ENABLE_DARWIN=1 ./scripts/darwin.sh"
  exit 1
fi

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# nix env (best effort)
if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
  . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
elif [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# darwin-rebuild を flake 入力から取得して、その switch だけ root で実行する
DARWIN_REBUILD="$(nix run github:LnL7/nix-darwin --no-write-lock-file -- print-build-logs 2>/dev/null || true)"

# ↑は無理に取らなくていいので、素直に store の darwin-rebuild を直接呼ぶ
# nix run は darwin-rebuild を /nix/store/.../bin/darwin-rebuild に出すので、そのパスを使う
DARWIN_REBUILD="$(nix build --no-write-lock-file --print-out-paths github:LnL7/nix-darwin#darwin-rebuild | tail -n1)/bin/darwin-rebuild"

# root 実行でも HOME 等が /var/root に寄らないよう固定
sudo \
  HOME="$HOME" USER="$USER" LOGNAME="$LOGNAME" \
  PATH="/nix/var/nix/profiles/default/bin:/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin" \
  "$DARWIN_REBUILD" switch --flake "$REPO_DIR#default"
