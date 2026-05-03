{ ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;

      format = ''
        [┌─](bold bright-black) $hostname $directory $git_branch$git_status$fill$nodejs$custom.nix_shell$time
        [└─](bold bright-black) $character
      '';

      hostname = {
        ssh_only = false;
        format = "[$hostname](green)";
      };

      directory = {
        format = "[$path]($style)";
        style = "bold blue";
        truncation_length = 6;
        truncation_symbol = "";
        fish_style_pwd_dir_length = 1;
      };

      git_branch = {
        symbol = "";
        format = " [on](white) [$branch](bold purple)";
      };

      git_status = {
        format = "[$all_status$ahead_behind]($style)";
        style = "bold red";
        conflicted = "=";
        ahead = "\${count}";
        behind = "\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        untracked = " ?\${count}";
        stashed = " *\${count}";
        modified = " !\${count}";
        staged = " +\${count}";
        renamed = " ~\${count}";
        deleted = " -\${count}";
      };

      nodejs = {
        symbol = " ";
        format = "[$symbol$version](green)  ";
      };

      custom.nix_shell = {
        when = ''test -n "$IN_NIX_SHELL"'';
        command = ''printf " %s" "$IN_NIX_SHELL"'';
        format = "[$output](blue)  ";
      };

      time = {
        disabled = false;
        format = "[$time](bright-black)";
        time_format = "%H:%M:%S";
      };
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };
      fill = {
        symbol = " ";
      };
    };
  };
}
