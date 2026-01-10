#!/usr/bin/env bash

detect_repo_root() {
  REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
  NIX_DIR="$REPO_ROOT/nix"
  export REPO_ROOT NIX_DIR
}

detect_hostkey() {
  HOSTKEY="$(scutil --get LocalHostName 2>/dev/null || true)"
  [[ -n "$HOSTKEY" ]] || die "LocalHostName is not set. Run: sudo scutil --set LocalHostName <key>"
  export HOSTKEY
}

# detect_ssh_setup
# sets:
#   SSH_GH_OK=1 if ssh -T git@github.com succeeds (non-interactive)
detect_ssh_setup() {
  SSH_GH_OK=0
  if command -v ssh >/dev/null 2>&1; then
    if ssh -o BatchMode=yes -o ConnectTimeout=5 -T git@github.com >/dev/null 2>&1; then
      SSH_GH_OK=1
    fi
  fi
  export SSH_GH_OK
}
