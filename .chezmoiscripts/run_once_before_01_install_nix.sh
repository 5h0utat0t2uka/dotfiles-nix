#!/bin/sh
set -eu

if command -v nix >/dev/null 2>&1; then
  exit 0
fi

# Determinate Systems installer（無対話）
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --no-confirm

# 念のため、現在のシェルに反映（失敗しても次回ログインで反映される）
if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi
