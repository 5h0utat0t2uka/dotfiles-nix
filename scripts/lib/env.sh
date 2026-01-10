#!/usr/bin/env bash
set -euo pipefail

# Exports:
# - HOSTKEY
# - FLAKE_DIR
# - CHEZMOI_DIR
# - USERNAME

detect_chezmoi_dir() {
  # If chezmoi exists, ask it. Otherwise assume canonical path.
  if command -v chezmoi >/dev/null 2>&1; then
    CHEZMOI_DIR="$(chezmoi source-path 2>/dev/null || true)"
  fi
  : "${CHEZMOI_DIR:=${HOME}/.local/share/chezmoi}"
  export CHEZMOI_DIR
}

detect_flake_dir() {
  FLAKE_DIR="${CHEZMOI_DIR}/nix"
  export FLAKE_DIR
}

detect_hostkey() {
  HOSTKEY="$(scutil --get LocalHostName 2>/dev/null || true)"
  [[ -n "${HOSTKEY}" ]] || return 1
  export HOSTKEY
}

detect_username() {
  USERNAME="${USER}"
  export USERNAME
}

detect_ssh_setup() {
  # "Stage0 is done?" lightweight check:
  # - ssh executable exists
  # - at least one key exists OR ssh-agent has keys
  local ok=0
  command -v ssh >/dev/null 2>&1 || return 1

  if compgen -G "${HOME}/.ssh/id_*" >/dev/null 2>&1; then
    ok=1
  fi

  # If agent has keys, also OK
  if ssh-add -L >/dev/null 2>&1; then
    ok=1
  fi

  (( ok )) || return 1
  return 0
}

detect_zshenv_conflict() {
  # nix-darwin activation fails if /etc/zshenv exists but is not managed by nix.
  # We move it aside idempotently.
  local f="/etc/zshenv"
  local backup="/etc/zshenv.before-nix-darwin"

  [[ -e "$f" ]] || return 0

  # If it's already a nix store symlink, it's fine.
  if [[ -L "$f" ]]; then
    local t
    t="$(readlink "$f" || true)"
    [[ "$t" == *"/nix/store/"* ]] && return 0
  fi

  # Already backed up → do nothing
  [[ -e "$backup" ]] && return 0

  sudo mv "$f" "$backup"
  echo "moved $f -> $backup"
}

detect_nix_store_volume() {
  # Returns 0 if an APFS volume named "Nix Store" exists.
  # We intentionally do NOT assume it's mounted.
  diskutil apfs list 2>/dev/null | grep -qE 'APFS Volume[[:space:]].*Nix Store|Name:[[:space:]]*Nix Store'
}
