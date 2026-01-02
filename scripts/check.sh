#!/usr/bin/env bash
set -euo pipefail

HOST="${1:-A3112}"

cd "${HOME}/.local/share/chezmoi"

nix flake check
nix build ".#darwinConfigurations.${HOST}.system"

sudo darwin-rebuild switch --flake ".#${HOST}"

ls -la /etc/static >/dev/null
command -v chezmoi git gh >/dev/null
command -v gpg pass pinentry-mac >/dev/null
brew list --cask | rg -q "ghostty"
echo "OK"
