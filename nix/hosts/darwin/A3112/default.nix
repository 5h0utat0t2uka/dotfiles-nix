{ ... }:

{
  imports = [
    ../../../modules/darwin/system.nix
    ../../../modules/darwin/homebrew.nix
  ];

  services.tailscale.enable = true;
}
