# nix/overlays/soroit.nix
final: prev: {
  soroit-loose-lg = prev.stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "soroit-loose-lg";
    version = "1.4.3";

    src = prev.fetchurl {
      url = "https://github.com/omonomo/Soroit/releases/download/v${finalAttrs.version}/SoroitLooseLG_v${finalAttrs.version}.zip";
      sha256 = "8b3787e3672a1fcb553d4e656c33a98b2ec7267c8ce2f8bc10f705435652ea5a";
    };

    nativeBuildInputs = [ prev.unzip ];
    dontConfigure = true;
    dontBuild = true;

    unpackPhase = ''
      runHook preUnpack
      mkdir -p source
      unzip -q "$src" -d source
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/fonts

      # zip 内のフォントを階層問わず拾う
      found=0
      while IFS= read -r -d "" f; do
        found=1
        cp -v "$f" "$out/share/fonts/"
      done < <(find source -type f \( -iname '*.otf' -o -iname '*.ttf' \) -print0)

      if [ "$found" -eq 0 ]; then
        echo "No .otf/.ttf found in the zip. Contents:" >&2
        find source -maxdepth 3 -type f -print >&2
        exit 1
      fi
      runHook postInstall
    '';

    meta = with prev.lib; {
      description = "Soroit (Loose LG) font";
      homepage = "https://github.com/omonomo/Soroit";
      platforms = platforms.darwin ++ platforms.linux;
    };
  });
}
