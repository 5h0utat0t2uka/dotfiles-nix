{ inputs }:

final: prev: {
  codex = inputs.codex.packages.${prev.stdenv.hostPlatform.system}.default;
}
