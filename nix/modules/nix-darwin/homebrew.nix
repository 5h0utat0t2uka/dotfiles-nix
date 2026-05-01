{ ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    taps = [];
    brews = [
      # FIXME: issue: failing tests (https://github.com/nixos/nixpkgs/issues/476308)
      "termscp"
    ];
    casks = [
      "karabiner-elements"
      "ollama-app"
      "zed"
    ];
  };
}
