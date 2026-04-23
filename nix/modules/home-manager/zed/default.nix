{ pkgs, lib, ... }:

let
  version = "0.233.6";
  rev = "6e1c63029035871963113acaa25613f225f48e89";

  zed-latest = pkgs.zed-editor.overrideAttrs (old: {
    version = version;
    src = pkgs.fetchFromGitHub {
      owner = "zed-industries";
      repo = "zed";
      rev = rev;
      # 1回目のビルドエラーから正しい値に置き換える
      hash = lib.fakeHash;
    };
    # 2回目のビルドエラーから正しい値に置き換える
    cargoHash = lib.fakeHash;
  });
in
{
  programs.zed-editor = {
    enable = true;
    package = zed-latest;
    # GUI からの設定変更可否
    mutableUserSettings = false;
    mutableUserKeymaps = false;
    extensions = [
      "astro"
      "comment"
      "dockerfile"
      "emmet"
      "git-firefly"
      "html"
      "just"
      "lua"
      "make"
      "nix"
      "scss"
      "toml"
    ];
    userSettings = builtins.fromJSON (builtins.readFile ./settings.json);
    userKeymaps = builtins.fromJSON (builtins.readFile ./keymap.json);
    themes = {
      Nord-Custom = builtins.fromJSON (builtins.readFile ./themes/Nord-Custom.json);
    };
  };
}

# {
#   programs.zed-editor = {
#     enable = true;
#     package = pkgs.zed-editor;
#     mutableUserSettings = false;
#     mutableUserKeymaps = false;
#     extensions = [
#       "astro"
#       "comment"
#       "dockerfile"
#       "emmet"
#       "git-firefly"
#       "html"
#       "just"
#       "lua"
#       "make"
#       "nix"
#       "scss"
#       "toml"
#     ];
#     userSettings = builtins.fromJSON (builtins.readFile ./settings.json);
#     userKeymaps = builtins.fromJSON (builtins.readFile ./keymap.json);
#     themes = {
#       Nord-Custom = builtins.fromJSON (builtins.readFile ./themes/Nord-Custom.json);
#     };
#   };
# }
