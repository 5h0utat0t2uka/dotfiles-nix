#!/usr/bin/env bash

log_step()    { printf "\n\033[1;34m==> %s\033[0m\n" "$*"; }
log_info()    { printf "  • %s\n" "$*"; }
log_warn()    { printf "\033[33mWARN:\033[0m %s\n" "$*" >&2; }
log_error()   { printf "\033[31mERROR:\033[0m %s\n" "$*" >&2; }
log_success() { printf "\n\033[1;32m✔ %s\033[0m\n" "$*"; }

die() { log_error "$*"; exit 1; }

# run <cmd...>
# DRY_RUN=1 のときは表示のみ
run() {
  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    log_info "[dry-run] $*"
    return 0
  fi
  log_info "$*"
  "$@"
}
