#!/usr/bin/env bash
set -euo pipefail

# Colors (only when TTY)
if [[ -t 1 ]]; then
  _c_reset=$'\033[0m'
  _c_dim=$'\033[2m'
  _c_red=$'\033[31m'
  _c_yel=$'\033[33m'
  _c_grn=$'\033[32m'
  _c_blu=$'\033[34m'
else
  _c_reset=""; _c_dim=""; _c_red=""; _c_yel=""; _c_grn=""; _c_blu=""
fi

log()  { printf '%s\n' "${_c_blu}==>${_c_reset} $*"; }
ok()   { printf '%s\n' "${_c_grn}OK${_c_reset}  $*"; }
warn() { printf '%s\n' "${_c_yel}WARN${_c_reset} $*"; }
err()  { printf '%s\n' "${_c_red}ERR${_c_reset}  $*" >&2; }

die()  { err "$*"; exit 1; }

# Global flags (set by setup.sh)
: "${DRY_RUN:=0}"
: "${LOG_FILE:=}"

_run_print() {
  if [[ -n "${LOG_FILE}" ]]; then
    printf '%s\n' "$*" | tee -a "${LOG_FILE}"
  else
    printf '%s\n' "$*"
  fi
}

run() {
  # Usage: run <cmd...>
  if (( DRY_RUN )); then
    _run_print "${_c_dim}[dry-run]${_c_reset} $*"
    return 0
  fi
  _run_print "${_c_dim}[run]${_c_reset} $*"
  "$@" 2>&1 | { if [[ -n "${LOG_FILE}" ]]; then tee -a "${LOG_FILE}"; else cat; fi; }
}

capture() {
  # Usage: capture <varname> -- <cmd...>
  local __var="$1"; shift
  [[ "$1" == "--" ]] || die "capture: missing --"
  shift
  local out=""
  if out="$("$@" 2>/dev/null)"; then
    printf -v "$__var" '%s' "$out"
    return 0
  else
    printf -v "$__var" '%s' ""
    return 1
  fi
}
