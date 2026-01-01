#!/bin/sh
set -eu
. "$(dirname "$0")/common.sh"

ensure_nix || { echo "nix not found"; exit 1; }

if [ "${DOTFILES_NIX_ENABLE_DARWIN:-}" != "1" ]; then
  echo "nix-darwin disabled. Run with DOTFILES_NIX_ENABLE_DARWIN=1"
  exit 1
fi

REPO_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
HOSTNAME="$(scutil --get LocalHostName 2>/dev/null || hostname -s)"

if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
elif [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
  . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
fi

sudo nix run github:LnL7/nix-darwin -- switch --flake "$REPO_DIR#${HOSTNAME}"
