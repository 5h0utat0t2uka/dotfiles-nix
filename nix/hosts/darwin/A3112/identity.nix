rec {
  system = "aarch64-darwin";
  hostname = "A3112";
  username = "shouta";
  homeDirectory = "/Users/${username}";
  flakeRoot = "${homeDirectory}/.local/share/chezmoi/nix";
  hasExistingHomebrew = false;
}
