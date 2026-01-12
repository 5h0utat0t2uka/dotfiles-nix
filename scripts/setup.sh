#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/lib"

source "${LIB_DIR}/log.sh"
source "${LIB_DIR}/env.sh"
source "${LIB_DIR}/nix.sh"
source "${LIB_DIR}/summary.sh"

usage() {
  cat <<'USAGE'
Usage: ./scripts/setup.sh [--dry-run] [--json] [--log PATH]
  --dry-run   Print commands without executing
  --json      Print summary JSON at the end (in addition to normal summary)
  --log PATH  Save output to PATH (append)
USAGE
}

PRINT_JSON=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift ;;
    --json) PRINT_JSON=1; shift ;;
    --log)
      LOG_FILE="${2:-}"
      [[ -n "${LOG_FILE}" ]] || die "--log requires a path"
      shift 2
      ;;
    -h|--help) usage; exit 0 ;;
    *) die "Unknown arg: $1" ;;
  esac
done

main() {
  detect_chezmoi_dir
  detect_flake_dir
  detect_zshenv_conflict
  detect_username

  if ! detect_hostkey; then
    _add_fail "LocalHostName is not set (Stage0 required): sudo scutil --set LocalHostName <hostKey>"
    print_summary
    exit 1
  fi
  _add_ok "Detected hostKey: ${HOSTKEY}"

  local host_dir="${FLAKE_DIR}/hosts/darwin/${HOSTKEY}"
  if [[ ! -d "${host_dir}" ]]; then
    _add_fail "Missing host directory: ${host_dir}"
    print_summary
    exit 1
  fi
  _add_ok "Host directory exists: ${host_dir}"

  # Stage0 checks (soft)
  if xcode-select -p >/dev/null 2>&1; then
    _add_ok "CLT installed (xcode-select -p)"
  else
    _add_warn "CLT not detected (run: xcode-select --install)"
  fi

  if detect_ssh_setup; then
    _add_ok "SSH setup looks present (key or agent)"
  else
    _add_warn "SSH setup not detected (key/agent) - repo access may fail"
  fi

  # Ensure nix (NO AUTO-INSTALL)
  if ensure_nix_present; then
    _add_ok "nix is present"
  else
    if detect_nix_store_volume; then
      _add_fail "nix not found, but APFS volume 'Nix Store' exists. Install Determinate Nix via Determinate.pkg. If the installer fails due to store/keychain mismatch, delete the 'Nix Store' volume first, then re-run the pkg installer."
    else
      _add_fail "nix not found. Install Determinate Nix via Determinate.pkg, then re-run ./scripts/setup.sh"
    fi
    print_summary
    exit 1
  fi

  # Switch
  darwin_switch_normal "${FLAKE_DIR}" "${HOSTKEY}"
  _add_ok "darwin switch executed"

  # Ensure login shell (UserShell) uses nix-darwin zsh
  ensure_login_shell_zsh

  # Post checks
  if command -v brew >/dev/null 2>&1; then
    _add_ok "brew is available: $(command -v brew)"
    _add_ok "brew prefix: $(brew --prefix 2>/dev/null || true)"
    _add_ok "brew candidates: $(type -a brew | tr '\n' ';' | sed 's/;*$//')"
  else
    _add_warn "brew not found after switch (check nix-homebrew config)"
  fi

  # /etc/zshrc contamination guard
  if [[ -r /etc/zshrc ]] && rg -n 'brew shellenv' /etc/zshrc >/dev/null 2>&1; then
    _add_warn "/etc/zshrc contains 'brew shellenv' (should be absent in this setup)"
  else
    _add_ok "/etc/zshrc has no 'brew shellenv'"
  fi

  if [[ -r /etc/zshrc ]] && rg -n '^\s*[^#].*\bpromptinit\b' /etc/zshrc >/dev/null 2>&1; then
    _add_warn "/etc/zshrc runs promptinit (should be absent / minimal)"
  else
    _add_ok "/etc/zshrc does not run promptinit"
  fi

  if [[ -r /etc/zshrc ]] && rg -n '^\s*[^#].*\bcompinit\b' /etc/zshrc >/dev/null 2>&1; then
    _add_warn "/etc/zshrc runs compinit (your user zshrc should own it)"
  else
    _add_ok "/etc/zshrc does not run compinit"
  fi

  print_summary
  if (( PRINT_JSON )); then
    print_summary_json
  fi
}

main "$@"
