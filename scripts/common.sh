#!/bin/sh
set -eu

ensure_nix() {
  if command -v nix >/dev/null 2>&1; then
    return 0
  fi

  # common PATH fallbacks
  export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"

  if command -v nix >/dev/null 2>&1; then
    return 0
  fi

  # profile scripts (best-effort)
  if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    # shellcheck disable=SC1090
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
  fi
  if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
    # shellcheck disable=SC1091
    . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
  fi

  command -v nix >/dev/null 2>&1
}
