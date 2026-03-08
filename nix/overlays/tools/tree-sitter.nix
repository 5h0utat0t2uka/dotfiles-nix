final: prev: {
  tree-sitter = prev.tree-sitter.overrideAttrs (old: {
    version = "0.26.1";
    src = prev.fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter";
      rev = "v0.26.1";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
  });
}
