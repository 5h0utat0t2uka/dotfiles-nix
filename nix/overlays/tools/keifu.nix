{ }:
final: prev: let
  pname = "keifu";
  version = "0.2.0"; # GitHub Releases の最新タグ
in {
  keifu = prev.rustPlatform.buildRustPackage rec {
    inherit pname version;

    src = prev.fetchFromGitHub {
      owner = "trasta298";
      repo  = "keifu";
      rev   = "v${version}";
      hash  = "sha256-AesG7d0FO+Oo+l+XqU4hDZM1w+L9e1ifcM0ohs+wHlY=";
    };

    cargoHash = "sha256-1FS75+O+HH3xqWGMa/RCvdZZ1jxRoEXgc3BTZ/Zux+Y=";
    meta = with prev.lib; {
      description = "TUI Git commit graph visualizer";
      license = licenses.mit;
      homepage = "https://github.com/trasta298/keifu";
    };
  };
}
