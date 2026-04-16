{ pkgs, lib, identity, inputs, ... }:

let
  zshPluginLinks = pkgs.linkFarm "zsh-plugin-links" [
    {
      name = "share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      path = "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
    }
    {
      name = "share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh";
      path = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh";
    }
    {
      name = "share/zsh/plugins/zsh-abbr/zsh-abbr.zsh";
      path = "${pkgs.zsh-abbr}/share/zsh/zsh-abbr/zsh-abbr.zsh";
    }
    {
      name = "share/zsh/plugins/powerlevel10k";
      path = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
    }
    # {
    #   name = "share/zsh/plugins/zeno.zsh/zeno.zsh";
    #   path = "${pkgs.zeno-zsh}/share/zeno.zsh/zeno.zsh";
    # }
    # {
    #   name = "share/zsh/plugins/zeno.zsh/zeno-bootstrap.zsh";
    #   path = "${pkgs.zeno-zsh}/share/zeno.zsh/zeno-bootstrap.zsh";
    # }
  ];
in
{
  # Issue: https://github.com/nix-community/home-manager/issues/7935
  manual = {
    manpages.enable = false;
  };

  # ドットファイルの実体は chezmoi で管理する前提なので
  # home-manager では生成しない
  programs = {
    zsh.enable = false;
    git.enable = false;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    wezterm = {
      enable = true;
      package = inputs.wezterm.packages.${pkgs.system}.default;
    };
  };

  xdg.configFile."wezterm/wezterm.lua".text = ''
    local wezterm = require("wezterm")
    local config = wezterm.config_builder()
    local scheme = 'nord'
    local mux = wezterm.mux
    local act = wezterm.action

    local function basename(path)
      return path:match("([^/]+)/*$") or path
    end
    local function file_path_from_uri(uri)
      if not uri then
        return nil
      end
      if type(uri) == "userdata" and uri.file_path then
        return uri.file_path
      end
      local s = tostring(uri)
      local path = s:gsub("^file://[^/]*", "")
      path = path:gsub("%%20", " ")
      return path
    end
    local function git_branch(cwd)
      if not cwd or cwd == "" then
        return nil
      end
      local ok_repo, stdout_repo = wezterm.run_child_process({
        "git",
        "-C",
        cwd,
        "rev-parse",
        "--is-inside-work-tree",
      })
      if not ok_repo or stdout_repo:gsub("%s+", "") ~= "true" then
        return nil
      end
      local ok_branch, stdout_branch = wezterm.run_child_process({
        "git",
        "-C",
        cwd,
        "branch",
        "--show-current",
      })
      if ok_branch then
        local branch = stdout_branch:gsub("%s+$", "")
        if branch ~= "" then
          return branch
        end
      end
      local ok_head, stdout_head = wezterm.run_child_process({
        "git",
        "-C",
        cwd,
        "rev-parse",
        "--short",
        "HEAD",
      })
      if ok_head then
        local head = stdout_head:gsub("%s+$", "")
        if head ~= "" then
          return head
        end
      end
      return nil
    end

    wezterm.on('gui-startup', function(window)
      local tab, pane, window = mux.spawn_window(cmd or {})
      local gui_window = window:gui_window();
      gui_window:maximize()
    end)

    wezterm.on("update-right-status", function(window, pane)
      local cwd_uri = pane:get_current_working_dir()
      local cwd = file_path_from_uri(cwd_uri)
      if not cwd then
        window:set_right_status("")
        return
      end
      local branch = git_branch(cwd)
      if not branch then
        window:set_right_status("")
        return
      end
      local dir = basename(cwd)
      window:set_right_status(wezterm.format({
        { Foreground = { Color = "#5E81AC" } },
        { Text = "" .. dir .. " " },
        { Foreground = { Color = "#5E81AC" } },
        { Text = " " .. branch .. "  " },
      }))
    end)

    wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
      local background = "#2E3440"
      local foreground = "#4C566A"
      local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "
      if tab.is_active then
        background = "#2E3440"
        foreground = "#5E81AC"
      end
      return {
        { Background = { Color = background } },
        { Foreground = { Color = foreground } },
        { Text = title },
      }
    end)

    config.native_macos_fullscreen_mode = false
    -- config.initial_cols = 205
    -- config.initial_rows = 100
    config.color_scheme = scheme
    config.use_ime = true
    config.leader = { key = "'", mods = "CTRL", timeout_milliseconds = 2000 }
    config.default_cursor_style = "BlinkingBlock"
    config.window_decorations = 'RESIZE'
    config.window_padding = { left = '1.5cell', right = '1.5cell', top = '1cell', bottom = '0cell' }
    config.window_background_gradient = {
      colors = { wezterm.get_builtin_color_schemes()[scheme].background }
    }
    config.window_frame = {
      font = require('wezterm').font 'GeistMono Nerd Font Mono',
      font_size = 15,
      inactive_titlebar_bg = "none",
      active_titlebar_bg = "none",
    }
    config.command_palette_bg_color = rgba(67, 76, 94, 0.8)
    config.command_palette_fg_color = rgba(216, 222, 233, 1.0)
    config.tab_max_width = 16
    config.use_fancy_tab_bar = true
    config.show_tabs_in_tab_bar = true
    config.tab_bar_at_bottom = false
    config.show_close_tab_button_in_tabs = true
    config.show_new_tab_button_in_tab_bar = false
    config.hide_tab_bar_if_only_one_tab = false
    config.cursor_blink_rate = 500
    config.animation_fps = 120
    config.harfbuzz_features = { 'calt = 0', 'clig = 0', 'liga = 0' }
    config.font_size = 14.6
    config.font = wezterm.font_with_fallback({
      "GeistMono Nerd Font Mono",
      "UDEV Gothic 35NF",
    })
    config.colors = {
      tab_bar = {
        background = "none",
        inactive_tab_edge = "none",
      },
    }
    config.keys = {
      -- pane splitting
      { key = '"', mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
      { key = "%", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
      -- pane navigation
      { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
      { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
      { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
      { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
      { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
      -- shell word movement
      { key = "LeftArrow", mods = "OPT", action = act.SendKey({ key = "b", mods = "ALT" }) },
      { key = "RightArrow", mods = "OPT", action = act.SendKey({ key = "f", mods = "ALT" }) },
      -- command palette
      { key = "p", mods = "SUPER", action = act.ActivateCommandPalette },
    }
    return config
  '';

  home = {
    stateVersion = "25.11";
    username = identity.username;
    homeDirectory = identity.homeDirectory;

    packages = with pkgs; [
      age
      bat
      chafa
      # claude-code
      copilot-language-server
      delta
      devbox
      eza
      fd
      fzf
      git
      gh
      ghq
      gifski
      glow
      gnupg
      just
      jq
      # pkgs.keifu
      libwebp
      lf
      lazygit
      lua-language-server
      macism
      mise
      neovim
      nb
      ni
      nixd
      nil
      nmap
      nodejs_24
      pnpm
      (pass.withExtensions (exts: [
        exts.pass-otp
      ]))
      pinentry_mac
      ripgrep
      # termscp
      # tree-sitter
      pkgs."tree-sitter-0267"
      tree
      tmux
      # uv
      viu
      vscode-langservers-extracted
      wget
      zbar
      zoxide
      # zeno-zsh
      zsh-syntax-highlighting
      zsh-autosuggestions
      zsh-completions
      zsh-abbr
      zsh-powerlevel10k
      zshPluginLinks
    ];

    activation.ensureNbConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "$HOME/.config/nb"
      if [ ! -e "$HOME/.config/nb/.nbrc" ]; then
        : > "$HOME/.config/nb/.nbrc"
      fi
    '';
  };
}
