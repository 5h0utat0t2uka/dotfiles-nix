{ ... }:

{
  # Homebrew 管理
  # 現状は cask だけでなく、一部 formula も含む
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    taps = [];
    brews = [
      # nixpkgs (darwin) で libsmbclient / dyld が壊れているため brew に逃がす
      # https://github.com/nixos/nixpkgs/issues/476308
      "termscp"
    ];
    casks = [
      "karabiner-elements"
      "ollama"
      "zed"
    ];
  };
}
