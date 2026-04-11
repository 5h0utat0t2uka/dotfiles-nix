(final: prev: {
  neovim-unwrapped = prev.neovim-unwrapped.overrideAttrs (old: {
    version = "0.12.1";
    src = prev.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "v0.12.1";
      hash = "sha256-cbFM5TKGmhEDsdhMvGzMyn0Js0MJwdMwXDkzQcdw/TM=";
      # hash = lib.fakeHash;
    };
  });
})
