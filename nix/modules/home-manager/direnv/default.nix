{ ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    # FIXME: Temporary workaround for zsh login startup hanging at
    # Related:
    # - https://github.com/NixOS/nixpkgs/issues/507531
    # - https://github.com/NixOS/nix/pull/15638
    # enableZshIntegration = false;
  };
}
