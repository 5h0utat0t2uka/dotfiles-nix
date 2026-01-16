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
      # 初めは placeholder（誤設定で失敗し、got: が出る）
      hash  = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };

    cargoLock = {
      lockFile = "Cargo.lock";
    };

    meta = with prev.lib; {
      description = "TUI Git commit graph visualizer";
      license = licenses.mit;
      homepage = "https://github.com/trasta298/keifu";
    };
  };
}
