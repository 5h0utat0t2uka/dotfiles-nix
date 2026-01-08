# nix/overlays/shcode-jp-zen-haku.nix
final: prev: {
  shcode-jp-zen-haku = prev.stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "shcode-jp-zen-haku";
    version = "1.0.1";

    src = prev.fetchurl {
      url = "https://github.com/hibara/SHCode-JP-Zen-Haku/releases/download/v${finalAttrs.version}/SHCodeJPZenHaku101.zip";
      sha256 = "sha256-enDqJe6Mek6OkjJMPnLUd6Uw+kQ4r0R2A3txuJxAbSs=";
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
      description = "SHCode JP Zen Haku font";
      homepage = "https://github.com/hibara/SHCode-JP-Zen-Haku";
      platforms = platforms.darwin ++ platforms.linux;
      # license は README / LICENSE を確認して必要なら追記
    };
  });
}
