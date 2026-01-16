{}:
final: prev:
let
  pname = "filetree";
  version = "0.3.2"; # GitHub Releases のタグに合わせる
in
{
  filetree = prev.rustPlatform.buildRustPackage {
    inherit pname version;

    src = prev.fetchFromGitHub {
      owner = "nyanko3141592";
      repo  = "filetree";
      rev   = "v${version}";
      hash  = "sha256-lm//C1xXxhWiaAwaE031au2nj+OxbNGYGiKks8/Llzw=";
    };

    cargoHash = "lib.fakeSha256";

    meta = with prev.lib; {
      description = "TUI file tree explorer (ft)";
      homepage = "https://github.com/nyanko3141592/filetree";
      license = licenses.mit;
      mainProgram = "ft";
    };
  };
}
