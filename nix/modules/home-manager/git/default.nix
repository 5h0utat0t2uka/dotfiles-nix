{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "5h0utat0t2uka";
    userEmail = "5h0utat0t2uka@gmail.com";
    ignores = [
      ".DS_Store"
      "**/.claude/settings.local.json"
    ];
    extraConfig = {
      core = {
        editor = "vim";
        pager = "delta";
      };
      interactive = { diffFilter = "delta --color-only"; };
      merge = { conflictstyle = "diff3"; };
      diff = { colorMoved = "default"; };
      init = { defaultBranch = "main"; };
      push = { autoSetupRemote = true; };
      url."git@github.com:" = {
        insteadOf = "https://github.com/";
      };
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
