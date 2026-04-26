{ inputs }:

final: prev:
let
  system = prev.stdenv.hostPlatform.system;
in
{
  codex = inputs.codex.packages.${system}.default;
}