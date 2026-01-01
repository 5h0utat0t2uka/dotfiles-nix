#!/bin/sh
set -eu

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BOOTSTRAP_CHEZMOI="$HOME/.local/bin/chezmoi"
IDENTITY_FILE="$REPO_DIR/config/identity.nix"

mkdir -p "$HOME/.local/bin" "$REPO_DIR/config"

# 1) bootstrap chezmoi（user-local）
if ! command -v chezmoi >/dev/null 2>&1; then
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
  export PATH="$HOME/.local/bin:$PATH"
fi

# 2) chezmoi apply
chezmoi init --source "$REPO_DIR" --apply

# 3) identity.nix を生成（chezmoi data に依存しない：OSから確実に取得）
USERNAME="$(id -un)"

# macOSでは scutil が安定。失敗したら hostname にフォールバック
HOSTNAME="$(scutil --get LocalHostName 2>/dev/null || hostname -s 2>/dev/null || hostname)"

OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
  Darwin) OS_NIX="darwin" ;;
  *) echo "ERROR: unsupported OS: $OS" >&2; exit 1 ;;
esac

case "$ARCH" in
  arm64) ARCH_NIX="aarch64" ;;
  x86_64) ARCH_NIX="x86_64" ;;
  *) echo "ERROR: unsupported arch: $ARCH" >&2; exit 1 ;;
esac

SYSTEM="${ARCH_NIX}-${OS_NIX}"

# 既に identity.nix があり、system が埋まっているなら上書きしない（事故防止）
if [ -f "$IDENTITY_FILE" ] && grep -q 'system = ".*";' "$IDENTITY_FILE"; then
  :
else
  cat > "$IDENTITY_FILE" <<EOF
{
  username = "${USERNAME}";
  hostname = "${HOSTNAME}";
  homeDirectory = "/Users/${USERNAME}";
  system = "${SYSTEM}";
}
EOF
fi

# 4) Nix をインストール（未インストールなら）
if ! command -v nix >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
fi

# 5) nix env load
if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
  . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
fi

# 6) flakes 有効化
mkdir -p "$HOME/.config/nix"
if ! grep -q "nix-command" "$HOME/.config/nix/nix.conf" 2>/dev/null; then
  echo "experimental-features = nix-command flakes" >> "$HOME/.config/nix/nix.conf"
fi

# 7) home-manager 実行
nix run github:nix-community/home-manager -- switch --flake "$REPO_DIR#${USERNAME}"

# 8) bootstrap chezmoi 削除（Nix 管理の chezmoi が優先されていれば削除）
# 例: /nix/store/...-chezmoi-.../bin/chezmoi や ~/.nix-profile/bin/chezmoi 等
CHEZMOI_PATH="$(command -v chezmoi || true)"
case "$CHEZMOI_PATH" in
  *"/nix/store/"*|*"/.nix-profile/"*)
    rm -f "$BOOTSTRAP_CHEZMOI" 2>/dev/null || true
    ;;
esac

echo "Done. Please re-login."
