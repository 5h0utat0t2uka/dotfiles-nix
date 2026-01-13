#!/usr/bin/env bash
# ============================================================
# setup.sh
# macOS (nix-darwin) をこのリポジトリの flake で switch し、必要な前提チェックや既存設定との衝突回避を行うエントリポイント。
#
# - Determinate Nix の事前インストールを選定にし、setup.sh が Nix を自動インストールしない
# - hostKey は LocalHostName（scutil）を強制し、hosts/darwin/<hostKey> が無い場合は失敗して終了
# - /etc の衝突（例: /etc/zshenv）を setup.sh 側で吸収して冪等化する
# ============================================================

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/lib"

# ログ/環境/ Nix関連 / サマリ出力の共通関数
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

# ------------------------------------------------------------
# 引数チェック
# - DRY_RUN は env.sh 等で既定値が入っている想定（ここでは指定時のみ DRY_RUN=1）
# - --json は最後に summary JSON も出す
# - --log は log.sh 側の仕組みに渡す想定（LOG_FILE）
# ------------------------------------------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --json)
      PRINT_JSON=1
      shift
      ;;
    --log)
      LOG_FILE="${2:-}"
      [[ -n "${LOG_FILE}" ]] || die "--log requires a path"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "Unknown arg: $1"
      ;;
  esac
done

main() {
  # ----------------------------------------------------------
  # 1. 事前検出
  # - chezmoi 管理ディレクトリの検出
  # - flake ディレクトリ（nix/）の検出
  # - /etc/zshenv など、nix-darwin activation を止めうる衝突の回避
  # - username の検出
  # ----------------------------------------------------------
  detect_chezmoi_dir
  detect_flake_dir
  detect_zshenv_conflict
  detect_username

  # ----------------------------------------------------------
  # 2. hostKey（LocalHostName）確定
  # - ホスト名を取れない場合は強制終了
  # ----------------------------------------------------------
  if ! detect_hostkey; then
    _add_fail "LocalHostName is not set (Stage0 required): sudo scutil --set LocalHostName "
    print_summary
    exit 1
  fi
  _add_ok "Detected hostKey: ${HOSTKEY}"

  # ----------------------------------------------------------
  # 3. hosts/darwin/<hostKey> の存在確認
  # - hostKey が正しい＝該当ホスト構成が repo に存在することを確認して、無ければ終了
  # ----------------------------------------------------------
  local host_dir="${FLAKE_DIR}/hosts/darwin/${HOSTKEY}"
  if [[ ! -d "${host_dir}" ]]; then
    _add_fail "Missing host directory: ${host_dir}"
    print_summary
    exit 1
  fi
  _add_ok "Host directory exists: ${host_dir}"

  # ----------------------------------------------------------
  # 4.チェック
  # - 失敗しても setup を止めず、ワーニングを出す
  # ----------------------------------------------------------
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

  # ----------------------------------------------------------
  # 5. Nix の存在確認
  # - Determinate Nix を前提として、ここで直接インストールは行わない
  # - nix が無い場合や、以前インストールして`Nix Store`ボリュームが存在していた場合などの確認
  # ----------------------------------------------------------
  if ensure_nix_present; then
    _add_ok "nix is present"
  else
    if detect_nix_store_volume; then
      _add_fail "nix not found, but APFS volume 'Nix Store' exists.
Install Determinate Nix via Determinate.pkg. If the installer fails due to store/keychain mismatch, delete the 'Nix Store' volume first, then re-run the pkg installer."
    else
      _add_fail "nix not found.
Install Determinate Nix via Determinate.pkg, then re-run ./scripts/setup.sh"
    fi
    print_summary
    exit 1
  fi

  # ----------------------------------------------------------
  # 6. nix-darwin switch
  # - flake_dir と hostKey を指定して switch
  # - ここで flake.nix が評価され、darwinConfigurations.<hostKey> が適用される
  # ----------------------------------------------------------
  darwin_switch_normal "${FLAKE_DIR}" "${HOSTKEY}"
  _add_ok "darwin switch executed"

  # ----------------------------------------------------------
  # 7. ログインシェル（UserShell）を nix-darwin の zsh に寄せる
  # - /run/current-system/sw/bin/zsh になっていることを期待
  # - 条件付きで chsh を実行
  # - dry-run では実行せず、失敗はワーニング扱い
  # ----------------------------------------------------------
  ensure_login_shell_zsh

  # ----------------------------------------------------------
  # 8. 事後チェック
  # - nix-homebrew が期待どおり入ったかを見る
  # ----------------------------------------------------------
  if command -v brew >/dev/null 2>&1; then
    _add_ok "brew is available: $(command -v brew)"
    _add_ok "brew prefix: $(brew --prefix 2>/dev/null || true)"
    _add_ok "brew candidates: $(type -a brew | tr '\n' ';' | sed 's/;*$//')"
  else
    _add_warn "brew not found after switch (check nix-homebrew config)"
  fi

  # ----------------------------------------------------------
  # 9. /etc/zshrc の汚染ガード
  # - system 側は最小化し、brew shellenv / promptinit / compinit などの設定はユーザー側のドットファイルに持たせる
  # - /etc/zshrc にそれらが混入していないかをチェックする
  # ----------------------------------------------------------
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

  # ----------------------------------------------------------
  # 10. 最終サマリ
  # - print_summary は常に出す
  # - --json 指定時は JSON も追加で出す
  # ----------------------------------------------------------
  print_summary
  if (( PRINT_JSON )); then
    print_summary_json
  fi
}

main "$@"
