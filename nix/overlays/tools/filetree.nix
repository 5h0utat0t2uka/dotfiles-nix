{}:
final: prev:
let
  pname = "filetree";
  version = "0.3.2"; # GitHub Releases のタグに合わせる :contentReference[oaicite:1]{index=1}
in
{
  filetree = prev.rustPlatform.buildRustPackage {
    inherit pname version;

    src = prev.fetchFromGitHub {
      owner = "nyanko3141592";
      repo  = "filetree";
      rev   = "v${version}";
      hash  = prev.lib.fakeHash;   # ← 後で埋める
    };

    cargoHash = prev.lib.fakeHash; # ← 後で埋める

    meta = with prev.lib; {
      description = "TUI file tree explorer (ft)";
      homepage = "https://github.com/nyanko3141592/filetree";
      license = licenses.mit;
      mainProgram = "ft";
    };
  };
}
