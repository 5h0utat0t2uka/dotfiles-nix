#!/usr/bin/env bash
set -euo pipefail

# Exports:
#  - HOSTKEY
#  - FLAKE_DIR
#  - CHEZMOI_DIR
#  - USERNAME

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
