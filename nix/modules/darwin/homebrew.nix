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
      {
        name = "bjarneo/cliamp/cliamp";
        args = [ "without-yt-dlp" ];
      }
    ];

    casks = [
      "ghostty"
      "karabiner-elements"
      "zed"
    ];
  };
}
