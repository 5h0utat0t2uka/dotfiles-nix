final: prev: {
  tree-sitter-0261 = prev.rustPlatform.buildRustPackage rec {
    pname = "tree-sitter";
    version = "0.26.1";

    src = prev.fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter";
      tag = "v${version}";
      hash = "sha256-k8X2qtxUne8C6znYAKeb4zoBf+vffmcJZQHUmBvsilA=";
      fetchSubmodules = true;
    };

    cargoHash = prev.lib.fakeHash;

    nativeBuildInputs = [ prev.which ];
    doCheck = false;

    meta = with prev.lib; {
      mainProgram = "tree-sitter";
    };
  };
}
