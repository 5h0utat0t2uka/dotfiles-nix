# nix/overlays/claude-code.nix

{ inputs }:
final: prev:
let
  system = prev.stdenv.hostPlatform.system;
in
{
  # pkgs.claude-code を inputs の最新版に差し替える
  claude-code = inputs.claude-code.packages.${system}.claude-code;
}
