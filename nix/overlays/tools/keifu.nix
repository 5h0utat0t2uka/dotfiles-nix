{ ... }:

final: prev: {
  keifu = prev.rustPlatform.buildRustPackage rec {
    pname = "keifu";
    version = "0.3.0";
    src = prev.fetchFromGitHub {
      owner = "trasta298";
      repo = "keifu";
      rev = "v${version}";
      hash = "sha256-Srw71Rswafu70kKI36dY1PtB4BQhpTYYzqbrWJuvaUM=";
    };
    cargoHash = "sha256-Ga405TV1uDSZbADrV+3aAeLDRfdPFHzdxxTEDu+f+b4=";
    nativeBuildInputs = with prev; [
      pkg-config
      perl
    ];
    meta = with prev.lib; {
      homepage = "https://github.com/trasta298/keifu";
      description = "A TUI tool to visualize Git commit graphs with branch genealogy";
      license = licenses.mit;
      mainProgram = "keifu";
    };
  };
}
