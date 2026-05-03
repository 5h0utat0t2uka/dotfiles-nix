{ ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      scan_timeout = 25;
      command_timeout = 500;
      add_newline = true;

      format = ''
        [┌─](bold bright-black) $hostname $directory $git_branch$git_status$fill$cmd_duration$nodejs''${custom.nix_shell}$time
        [└─](bold bright-black) $character
      '';

      hostname = {
        ssh_only = false;
        format = "[$hostname](green)";
      };
      directory = {
        format = "[$path]($style)";
        style = "blue";
        truncation_length = 6;
        truncation_symbol = "";
        fish_style_pwd_dir_length = 1;
      };
      git_branch = {
        symbol = "";
        format = "[on](white) [$branch](green)";
      };
      git_status = {
        format = "$all_status$ahead_behind";
        conflicted = "[ =\${count}](bold red)";
        ahead = "[ \${count}](blue)";
        behind = "[ \${count}](blue)";
        diverged = "[ ⇕⇡\${ahead_count}\${behind_count}](purple)";
        untracked = "[ ?\${count}](blue)";
        stashed = "[ *\${count}](purple)";
        modified = "[ !\${count}](yellow)";
        staged = "[ +\${count}](green)";
        renamed = "[ ~\${count}](purple)";
        deleted = "[ -\${count}](red)";
      };
      cmd_duration = {
        min_time = 3000;
        format = "[$duration](yellow)  ";
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
