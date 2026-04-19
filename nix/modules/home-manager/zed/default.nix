{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;

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
