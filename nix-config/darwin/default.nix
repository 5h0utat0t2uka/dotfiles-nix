{ ... }:

let
  identity = import ../../config/identity.nix;
  username = identity.username;

  # Phase D でここに casks を移管していく（最初は最小から）
  casks = [
    # 例: "ghostty"
  ];
in
{
  system.stateVersion = 5;

  # Determinate を使うなら衝突回避
  nix.enable = false;

  # Homebrewモジュールは「brewが既に入っている」前提で動く
  system.primaryUser = username;

  homebrew = {
    enable = true;

    # Phase D: まずは cleanup を "none" のまま移管する
    onActivation = {
      autoUpdate = false;
      upgrade = false;

      # Phase E で "uninstall" か "zap" に変更する（宣言外は削除）
      cleanup = "none";
      # checkCleanup = true;  # 任意: darwin-rebuild check で差分検知（環境により）
    };

    casks = casks;
  };
}
