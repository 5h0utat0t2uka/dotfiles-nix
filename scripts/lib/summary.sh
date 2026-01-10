#!/usr/bin/env bash
set -euo pipefail

# Collects and prints final summary.
# Requires: log.sh for ok/warn/err
# Expects arrays:
#   SUMMARY_OK, SUMMARY_WARN, SUMMARY_FAIL
# And vars:
#   HOSTKEY, FLAKE_DIR, CHEZMOI_DIR, DRY_RUN, LOG_FILE

SUMMARY_OK=()
SUMMARY_WARN=()
SUMMARY_FAIL=()

_add_ok()   { SUMMARY_OK+=("$*"); }
_add_warn() { SUMMARY_WARN+=("$*"); }
_add_fail() { SUMMARY_FAIL+=("$*"); }

check_and_record() {
  # Usage: check_and_record "<label>" -- <cmd...>
  local label="$1"; shift
  [[ "$1" == "--" ]] || die "check_and_record: missing --"
  shift
  if "$@" >/dev/null 2>&1; then
    _add_ok "${label}"
  else
    _add_warn "${label}"
  fi
}

hard_check_or_fail() {
  # Usage: hard_check_or_fail "<label>" -- <cmd...>
  local label="$1"; shift
  [[ "$1" == "--" ]] || die "hard_check_or_fail: missing --"
  shift
  if "$@" >/dev/null 2>&1; then
    _add_ok "${label}"
  else
    _add_fail "${label}"
  fi
}

collect_facts() {
  # Exports FACT_* vars used by print_summary / json
  FACT_USER="${USER}"
  FACT_HOSTKEY="${HOSTKEY:-}"
  FACT_FLAKE_DIR="${FLAKE_DIR:-}"
  FACT_CHEZMOI_DIR="${CHEZMOI_DIR:-}"
  FACT_DRY_RUN="${DRY_RUN}"

  FACT_NIX="$(command -v nix 2>/dev/null || true)"
  FACT_NIX_VER="$(nix --version 2>/dev/null || true)"
  FACT_DARWIN_REBUILD="$(command -v darwin-rebuild 2>/dev/null || true)"

  FACT_BREW_TYPE="$(type -a brew 2>/dev/null | sed -e 's/^/  /' || true)"
  FACT_BREW_PREFIX="$(brew --prefix 2>/dev/null || true)"

  FACT_PATH_HEAD="$(echo "$PATH" | tr ':' '\n' | head -n 12 | sed -e 's/^/  /')"

  # /etc/zshrc checks
  if [[ -r /etc/zshrc ]]; then
    if rg -n 'brew shellenv' /etc/zshrc >/dev/null 2>&1; then
      FACT_ETC_ZSHRC_BREW_SHELLENV="present"
    else
      FACT_ETC_ZSHRC_BREW_SHELLENV="absent"
    fi
    if rg -n 'promptinit|prompt suse' /etc/zshrc >/dev/null 2>&1; then
      FACT_ETC_ZSHRC_PROMPT="present"
    else
      FACT_ETC_ZSHRC_PROMPT="absent"
    fi
    if rg -n 'autoload -U compinit|compinit' /etc/zshrc >/dev/null 2>&1; then
      FACT_ETC_ZSHRC_COMPINIT="present"
    else
      FACT_ETC_ZSHRC_COMPINIT="absent"
    fi
  else
    FACT_ETC_ZSHRC_BREW_SHELLENV="unknown"
    FACT_ETC_ZSHRC_PROMPT="unknown"
    FACT_ETC_ZSHRC_COMPINIT="unknown"
  fi
}

print_summary() {
  collect_facts

  printf '\n'
  log "Summary"
  printf '%s\n' "  user:    ${FACT_USER}"
  printf '%s\n' "  hostKey:  ${FACT_HOSTKEY}"
  printf '%s\n' "  flake:    ${FACT_FLAKE_DIR}"
  printf '%s\n' "  chezmoi:  ${FACT_CHEZMOI_DIR}"
  printf '%s\n' "  mode:     $([[ "${FACT_DRY_RUN}" == "1" ]] && echo dry-run || echo apply)"
  [[ -n "${LOG_FILE}" ]] && printf '%s\n' "  log:      ${LOG_FILE}"

  printf '\n'
  log "Key facts"
  printf '%s\n' "  nix:      ${FACT_NIX}"
  printf '%s\n' "  nix ver:  ${FACT_NIX_VER}"
  printf '%s\n' "  darwin:   ${FACT_DARWIN_REBUILD}"
  printf '%s\n' "  brew prefix: ${FACT_BREW_PREFIX}"
  printf '%s\n' "  brew candidates:"
  printf '%s\n' "${FACT_BREW_TYPE:-  <none>}"
  printf '%s\n' "  PATH (head):"
  printf '%s\n' "${FACT_PATH_HEAD}"

  printf '\n'
  log "/etc/zshrc checks"
  printf '%s\n' "  brew shellenv: ${FACT_ETC_ZSHRC_BREW_SHELLENV}"
  printf '%s\n' "  promptinit:    ${FACT_ETC_ZSHRC_PROMPT}"
  printf '%s\n' "  compinit:      ${FACT_ETC_ZSHRC_COMPINIT}"

  printf '\n'
  if ((${#SUMMARY_FAIL[@]})); then
    err "Failed: ${#SUMMARY_FAIL[@]}"
    printf '%s\n' "${SUMMARY_FAIL[@]}" | sed -e 's/^/  - /'
  else
    ok "Failed: 0"
  fi

  if ((${#SUMMARY_WARN[@]})); then
    warn "Warnings: ${#SUMMARY_WARN[@]}"
    printf '%s\n' "${SUMMARY_WARN[@]}" | sed -e 's/^/  - /'
  else
    ok "Warnings: 0"
  fi

  if ((${#SUMMARY_OK[@]})); then
    ok "OK: ${#SUMMARY_OK[@]}"
  fi

  printf '\n'
  if ((${#SUMMARY_FAIL[@]})); then
    err "Result: FAILED"
    return 1
  fi
  ok "Result: SUCCESS"
  return 0
}

print_summary_json() {
  collect_facts
  # Minimal JSON without jq dependency
  # shellcheck disable=SC2016
  cat <<JSON
{
  "user": "$(printf '%s' "${FACT_USER}" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read().strip()))')",
  "hostKey": "$(printf '%s' "${FACT_HOSTKEY}" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read().strip()))')",
  "flakeDir": "$(printf '%s' "${FACT_FLAKE_DIR}" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read().strip()))')",
  "chezmoiDir": "$(printf '%s' "${FACT_CHEZMOI_DIR}" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read().strip()))')",
  "dryRun": ${FACT_DRY_RUN},
  "nixPath": "$(printf '%s' "${FACT_NIX}" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read().strip()))')",
  "nixVersion": "$(printf '%s' "${FACT_NIX_VER}" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read().strip()))')",
  "darwinRebuild": "$(printf '%s' "${FACT_DARWIN_REBUILD}" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read().strip()))')",
  "brewPrefix": "$(printf '%s' "${FACT_BREW_PREFIX}" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read().strip()))')",
  "etcZshrc": {
    "brewShellenv": "$(printf '%s' "${FACT_ETC_ZSHRC_BREW_SHELLENV}" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read().strip()))')",
    "promptinit": "$(printf '%s' "${FACT_ETC_ZSHRC_PROMPT}" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read().strip()))')",
    "compinit": "$(printf '%s' "${FACT_ETC_ZSHRC_COMPINIT}" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read().strip()))')"
  },
  "counts": {
    "ok": ${#SUMMARY_OK[@]},
    "warn": ${#SUMMARY_WARN[@]},
    "fail": ${#SUMMARY_FAIL[@]}
  }
}
JSON
}
