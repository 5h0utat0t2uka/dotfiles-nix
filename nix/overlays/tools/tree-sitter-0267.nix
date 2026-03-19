# NOTE: nixpkgsのtree-sitterのバージョンが`0.26.1`に上がるまでの暫定
# nixpkgsが追いついたら下記
# - `nix/overlays/tools/tree-sitter-0267.nix`を削除
# - `flake.nix`の`(import ./overlays/tools/tree-sitter-0267.nix)`を削除
# - `nix/modules/darwin/home-manager.nix`の`pkgs."tree-sitter-0267"`を`tree-sitter`に置き換える

final: prev: {
  tree-sitter-0267 = prev.rustPlatform.buildRustPackage rec {
    pname = "tree-sitter";
    version = "0.26.7";
    src = prev.fetchFromGitHub {
      owner = "tree-sitter";
      repo = "tree-sitter";
      tag = "v${version}";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      fetchSubmodules = true;
    };
    cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    nativeBuildInputs = [ prev.which ];
    doCheck = false;
    meta = with prev.lib; {
      mainProgram = "tree-sitter";
    };
  };
}
