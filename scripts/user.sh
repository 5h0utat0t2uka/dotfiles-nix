#!/bin/sh
set -eu

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BOOTSTRAP_CHEZMOI="$HOME/.local/bin/chezmoi"
IDENTITY_FILE="$REPO_DIR/config/identity.nix"

mkdir -p "$HOME/.local/bin" "$REPO_DIR/config"

# 1. bootstrap chezmoi（user-local）
if ! command -v chezmoi >/dev/null 2>&1; then
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
  export PATH="$HOME/.local/bin:$PATH"
fi

# 2. chezmoi apply
chezmoi init --source "$REPO_DIR" --apply

# 3. identity.nix を生成
USERNAME="$(chezmoi data | sed -n 's/^username: //p')"
HOSTNAME="$(chezmoi data | sed -n 's/^hostname: //p')"
SYSTEM="$(chezmoi data | sed -n 's/^system: //p')"

cat > "$IDENTITY_FILE" <<EOF
{
  username = "${USERNAME}";
  hostname = "${HOSTNAME}";
  homeDirectory = "/Users/${USERNAME}";
  system = "${SYSTEM}";
}
EOF

# 4. Nix（Determinate）をインストール
if ! command -v nix >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
    | sh -s -- install --no-confirm
fi

# 5. nix env load
if [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
  . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
fi

# 6. flakes 有効化
mkdir -p "$HOME/.config/nix"
grep -q flakes "$HOME/.config/nix/nix.conf" 2>/dev/null \
  || echo "experimental-features = nix-command flakes" >> "$HOME/.config/nix/nix.conf"

# 7. home-manager 実行
nix run github:nix-community/home-manager -- switch --flake "$REPO_DIR#${USERNAME}"

# 8. bootstrap chezmoi 削除
if command -v chezmoi | grep -q '.nix-profile'; then
  rm -f "$BOOTSTRAP_CHEZMOI" || true
fi

echo "Done. Please re-login."
