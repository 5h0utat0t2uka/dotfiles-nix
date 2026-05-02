{ pkgs, ... }:

let
  passWithOtp = pkgs.pass.withExtensions (exts: [
    exts.pass-otp
  ]);
  pass-nvim = pkgs.writeShellScriptBin "pass" ''
    exec env EDITOR=${pkgs.neovim}/bin/nvim VISUAL=${pkgs.neovim}/bin/nvim ${passWithOtp}/bin/pass "$@"
  '';
in
{
  home.packages = [
    pass-nvim
  ];
}
