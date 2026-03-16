# nix/overlays/tools/zeno-zsh.nix
final: prev: {
  zeno-zsh = prev.stdenvNoCC.mkDerivation rec {
    pname = "zeno-zsh";
    version = "unstable-2026-03-16";

    src = prev.fetchFromGitHub {
      owner = "yuki-yano";
      repo = "zeno.zsh";
      rev = "main";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };

    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/zeno.zsh
      cp -R . $out/share/zeno.zsh
      runHook postInstall
    '';

    meta = with prev.lib; {
      description = "Zsh fuzzy completion and utility plugin with Deno";
      homepage = "https://github.com/yuki-yano/zeno.zsh";
      license = licenses.mit;
      platforms = platforms.unix;
    };
  };
}