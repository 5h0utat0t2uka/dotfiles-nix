{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    ignores = [
      ".DS_Store"
      "**/.claude/settings.local.json"
    ];
    settings = {
      user = {
        name = "5h0utat0t2uka";
        email = "5h0utat0t2uka@gmail.com";
      };
      core = {
        editor = "vim";
        pager = "delta";
      };
      url."git@github.com:" = {
        insteadOf = "https://github.com/";
      };
      interactive = { diffFilter = "delta --color-only"; };
      merge = { conflictstyle = "diff3"; };
      diff = { colorMoved = "default"; };
      init = { defaultBranch = "main"; };
      push = { autoSetupRemote = true; };
      delta = {
        navigate = true;
        side-by-side = true;
        line-numbers = true;
        syntax-theme = "Nord";
        file-style = "bold green";
        file-decoration-style = "none";
        line-numbers-left-format = "{nm:>4} ";
        line-numbers-right-format = "{np:>4} ";
        hunk-header-decoration-style = "none";
      };
      ghq = {
        user = "5h0utat0t2uka";
        root = "~/Development/repositories";
      };
    };
  };
  home.packages = with pkgs; [
    delta
    ghq
  ];
}
