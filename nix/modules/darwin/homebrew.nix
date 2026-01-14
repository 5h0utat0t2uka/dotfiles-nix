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
    casks = [
      # "affinity"
      # "nikitabobko/tap/aerospace"
      "ghostty"
      "google-chrome"
      "karabiner-elements"
      "zed"
    ];
  };
}
