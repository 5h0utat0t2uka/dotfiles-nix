#!/bin/sh
set -eu
. "$(dirname "$0")/common.sh"

ensure_nix || echo "nix not yet installed"

REPO_DIR="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
BOOTSTRAP_CHEZMOI="$HOME/.local/bin/chezmoi"
IDENTITY_FILE="$REPO_DIR/config/identity.nix"

mkdir -p "$REPO_DIR/config" "$HOME/.local/bin"

# 1) bootstrap chezmoi (user-local)
if ! command -v chezmoi >/dev/null 2>&1; then
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
  export PATH="$HOME/.local/bin:$PATH"
fi

# 2) chezmoi apply (local source)
chezmoi init --source "$REPO_DIR" --apply

# 3) identity.nix generate from chezmoi data
USERNAME="$(chezmoi data | sed -n 's/^username: //p' | head -n1)"
HOSTNAME="$(chezmoi data | sed -n 's/^hostname: //p' | head -n1)"
SYSTEM="$(chezmoi data | sed -n 's/^system: //p' | head -n1)"
[ -n "$USERNAME" ] && [ -n "$HOSTNAME" ] && [ -n "$SYSTEM" ]

cat > "$IDENTITY_FILE" <<EOF
{
  username = "${USERNAME}";
  hostname = "${HOSTNAME}";
  homeDirectory = "/Users/${USERNAME}";
  system = "${SYSTEM}";
}
EOF

# 4) install nix if missing
if ! command -v nix >/dev/null 2>&1; then
  sh <(curl -L https://nixos.org/nix/install)
fi

# 5) load nix env (single-user / daemon)
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
elif [ -e "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
  . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
fi

# enable flakes (user)
mkdir -p "$HOME/.config/nix"
NIXCONF="$HOME/.config/nix/nix.conf"
touch "$NIXCONF"
grep -q '^experimental-features' "$NIXCONF" || \
  printf "\nexperimental-features = nix-command flakes\n" >> "$NIXCONF"

# 6) home-manager apply
nix run github:nix-community/home-manager -- switch --flake "$REPO_DIR#${USERNAME}"

# 7) delete bootstrap chezmoi when nix-managed is active
CHEZMOI_PATH="$(command -v chezmoi || true)"
if [ -n "$CHEZMOI_PATH" ] && echo "$CHEZMOI_PATH" | grep -q '/.nix-profile/bin/chezmoi'; then
  [ -f "$BOOTSTRAP_CHEZMOI" ] && rm -f "$BOOTSTRAP_CHEZMOI"
fi

echo "OK: home-manager applied. Re-login or: exec zsh -l"
