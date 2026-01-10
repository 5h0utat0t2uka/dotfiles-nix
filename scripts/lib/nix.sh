#!/usr/bin/env bash

ensure_host_config_exists() {
  local host_dir="$NIX_DIR/hosts/darwin/$HOSTKEY"
  [[ -d "$host_dir" ]] || die "Host config not found: nix/hosts/darwin/$HOSTKEY
Create it, commit/push, then re-run."
}

install_determinate_nix_if_needed() {
  if command -v nix >/dev/null 2>&1; then
    log_info "Nix already installed: $(command -v nix)"
    return 0
  fi

  log_step "Installing Determinate Nix"
  # Determinate installer (interactive parts are handled by the installer)
  run curl -fsSL https://install.determinate.systems/nix
  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    log_info "[dry-run] curl ... | sh -s -- install"
  else
    curl -fsSL https://install.determinate.systems/nix | sh -s -- install
  fi
}

run_darwin_rebuild() {
  log_step "Running darwin-rebuild switch"

  if command -v darwin-rebuild >/dev/null 2>&1; then
    run darwin-rebuild switch --flake "$NIX_DIR#$HOSTKEY"
  else
    # first-time bootstrap
    run nix run github:LnL7/nix-darwin -- switch --flake "$NIX_DIR#$HOSTKEY"
  fi
}
