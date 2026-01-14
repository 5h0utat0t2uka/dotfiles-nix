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

    casks = [
      # "affinity"
      "aerospace"
      "ghostty"
      "google-chrome"
      "karabiner-elements"
      "zed"
    ];
  };
}
