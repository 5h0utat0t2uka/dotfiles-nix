{ identity, ... }:

{
  # Homebrew は GUI アプリ（cask）のみを管理
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
      # "affinity"
      # "nikitabobko/tap/aerospace"
      "firefox@developer-edition"
      "ghostty"
      "google-chrome"
      "karabiner-elements"
      "zed"
    ];
  };
}
