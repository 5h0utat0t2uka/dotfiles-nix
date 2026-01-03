{ pkgs }:

pkgs.stdenvNoCC.mkDerivation {
  pname = "udev-gothic-nf";
  version = "2.1.0";

  src = pkgs.fetchzip {
    url = "https://github.com/yuru7/udev-gothic/releases/download/v2.1.0/UDEVGothic_NF_v2.1.0.zip";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    stripRoot = false;
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    find . -type f \( -iname "*.ttf" -o -iname "*.otf" \) -exec cp -v {} $out/share/fonts/truetype/ \;
  '';

  meta = with pkgs.lib; {
    description = "UDEV Gothic Nerd Font";
    homepage = "https://github.com/yuru7/udev-gothic";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
