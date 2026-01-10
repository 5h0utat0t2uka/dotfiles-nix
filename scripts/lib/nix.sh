#!/usr/bin/env bash
set -euo pipefail

# Requires: log.sh for run/capture/die

is_determinate_nix() {
  # Heuristic: Determinate installs nix under /nix/var/nix/profiles/default/bin
  # local nix_path=""
  # nix_path="$(command -v nix 2>/dev/null || true)"
  # [[ "${nix_path}" == "/nix/var/nix/profiles/default/bin/nix" ]]
  nix --version 2>/dev/null | rg -q 'Determinate Nix'
}

ensure_nix_present() {
  command -v nix >/dev/null 2>&1 || return 1
  return 0
}

install_determinate_nix() {
  # Minimal, non-interactive install. (You can adjust later if you want prompts.)
  # Official installer endpoint:
  # https://install.determinate.systems/nix
  #
  # NOTE: this runs as root via the installer script.
  run sh -c 'curl -fsSL https://install.determinate.systems/nix | sh -s -- install --no-confirm'
}

darwin_switch_first_time() {
  # Use nix run for first-time switch (works even if darwin-rebuild not in PATH yet)
  # Usage: darwin_switch_first_time <flakeDir> <hostKey>
  local flake_dir="$1"
  local hostkey="$2"
  run sudo nix run github:LnL7/nix-darwin -- switch --flake "${flake_dir}#${hostkey}"
}

darwin_switch_normal() {
  # Usage: darwin_switch_normal <flakeDir> <hostKey>
  local flake_dir="$1"
  local hostkey="$2"

  if command -v darwin-rebuild >/dev/null 2>&1; then
    run sudo darwin-rebuild switch --flake "${flake_dir}#${hostkey}"
  else
    run sudo nix run github:LnL7/nix-darwin -- switch --flake "${flake_dir}#${hostkey}"
  fi
}

load_nix_profile() {
  # Determinate / multi-user nix の典型
  if [[ -r /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
    # shellcheck disable=SC1091
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  elif [[ -r /nix/var/nix/profiles/default/etc/profile.d/nix.sh ]]; then
    # shellcheck disable=SC1091
    . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
  fi
}
