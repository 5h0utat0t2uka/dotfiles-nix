#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
LIB_DIR="$SCRIPT_DIR/lib"

# shellcheck source=/dev/null
. "$LIB_DIR/log.sh"
. "$LIB_DIR/env.sh"
. "$LIB_DIR/nix.sh"

usage() {
  cat <<'EOF'
Usage: ./setup.sh [--dry-run]

Stage0 (manual):
  - Set HostName
  - Install CLT
  - Prepare SSH key (generate or securely migrate) so repo access works
EOF
}

DRY_RUN=0
case "${1:-}" in
  --dry-run) DRY_RUN=1 ;;
  "" ) ;;
  -h|--help) usage; exit 0 ;;
  *) die "Unknown option: $1" ;;
esac
export DRY_RUN

log_step "Starting setup"
detect_repo_root
detect_hostkey
detect_ssh_setup

log_step "Check env"
command -v git >/dev/null 2>&1 || die "git not found (install CLT)"
command -v ssh >/dev/null 2>&1 || die "ssh not found (install CLT)"
if [[ "${SSH_GH_OK:-0}" == "1" ]]; then
  log_info "SSH to GitHub looks OK (BatchMode)"
else
  log_warn "SSH to GitHub not confirmed. If repo access fails, fix SSH key / known_hosts."
fi

ensure_host_config_exists
install_determinate_nix_if_needed
run_darwin_rebuild

log_step "Summary"
log_info "HOSTKEY: $HOSTKEY"
log_info "flake:   $NIX_DIR#$HOSTKEY"

if command -v nix >/dev/null 2>&1; then
  log_info "nix:     $(command -v nix)"
fi

if command -v darwin-rebuild >/dev/null 2>&1; then
  log_info "darwin-rebuild: $(command -v darwin-rebuild)"
fi

if command -v brew >/dev/null 2>&1; then
  log_info "brew:    $(command -v brew)"
  # dry-run でもこの2つは安全に読めるが、brewが対話するケースはゼロではないので抑制
  if [[ "${DRY_RUN:-0}" != "1" ]]; then
    log_info "prefix:  $(brew --prefix 2>/dev/null || echo "<failed>")"
    log_info "brew -v: $(brew --version 2>/dev/null | head -n 1 || echo "<failed>")"
  fi
else
  log_warn "brew not found after rebuild (check nix-homebrew/homebrew module config)"
fi

log_success "Done"
