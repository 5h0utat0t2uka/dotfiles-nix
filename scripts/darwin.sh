#!/bin/sh
set -eu

if [ "${DOTFILES_NIX_ENABLE_DARWIN:-}" != "1" ]; then
  echo "nix-darwin is disabled."
  echo "Run with: DOTFILES_NIX_ENABLE_DARWIN=1 ./scripts/darwin.sh"
  exit 1
fi

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# nix 環境の読み込み（best effort）
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
elif [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
  . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
fi

sudo nix run github:LnL7/nix-darwin -- switch --flake "$REPO_DIR#default"
