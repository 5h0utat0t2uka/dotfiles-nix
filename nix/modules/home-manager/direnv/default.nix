{ pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    package = pkgs.direnv.overrideAttrs (old: {
      # Darwin でチェックをスキップ
      # https://github.com/NixOS/nixpkgs/issues/507531?utm_source=chatgpt.com
      doCheck = (old.doCheck or true) && !pkgs.stdenv.isDarwin;
    });
    nix-direnv.enable = true;
  };
}
