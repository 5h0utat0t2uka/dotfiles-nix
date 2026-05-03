{ ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      scan_timeout = 25;
      command_timeout = 500;
      add_newline = true;
      format = ''
        [┌─](bold bright-black) $hostname $directory $git_branch$git_status$fill$cmd_duration$nodejs$nix_shell$time
        [└─](bold bright-black) $character
      '';

      character = {
        success_symbol = "[❯](green)";
        error_symbol = "[❯](red)";
      };
      fill = {
        symbol = " ";
      };
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
        diverged = "[ \${ahead_count}\${behind_count}](purple)";
        untracked = "[ ?\${count}](blue)";
        stashed = "[ *\${count}](purple)";
        modified = "[ !\${count}](yellow)";
        staged = "[ +\${count}](green)";
        renamed = "[ ~\${count}](yellow)";
        deleted = "[ -\${count}](red)";
      };
      cmd_duration = {
        min_time = 3000;
        format = "[$duration](yellow)  ";
      };
      bun = {
        symbol = " ";
        version_format = "$raw";
        format = "[$symbol$version](green)  ";
      };
      nodejs = {
        symbol = " ";
        version_format = "$raw";
        format = "[$symbol$version](green)  ";
      };
      nix_shell = {
        symbol = " ";
        format = "[$symbol$state](blue)  ";
        impure_msg = "impure";
        pure_msg = "pure";
      };
      time = {
        disabled = false;
        format = "[$time](bright-black)";
        time_format = "%H:%M:%S";
      };
    };
  };
}
