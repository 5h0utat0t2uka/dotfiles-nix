{ identity, ... }:

{
  # Homebrew は GUI アプリ（cask）のみを管理
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "none";
    };

    casks = [
      # "affinity"
      "ghostty"
      "google-chrome"
      "karabiner-elements"
      "zed"
    ];
  };
}
