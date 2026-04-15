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
    local mux = wezterm.mux

    config.native_macos_fullscreen_mode = false

    wezterm.on('gui-startup', function(window)
      local tab, pane, window = mux.spawn_window(cmd or {})
      local gui_window = window:gui_window();
      gui_window:maximize()
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

    config.color_scheme = "nord"
    config.use_ime = true
    -- config.leader = { key = "`", mods = "CTRL", timeout_milliseconds = 2000 }
    config.default_cursor_style = "BlinkingBlock"
    config.window_decorations = 'RESIZE | MACOS_FORCE_DISABLE_SHADOW'
    config.window_padding = { left = '1cell', right = '1cell', top = '1cell', bottom = '0cell' }
    config.window_background_gradient = {
      colors = { "#2E3440" },
    }
    config.window_frame = {
      font = require('wezterm').font 'GeistMono Nerd Font Mono',
      font_size = 12,
    }
    -- config.enable_tab_bar = false
    config.tab_max_width = 16
    config.use_fancy_tab_bar = false
    config.show_tabs_in_tab_bar = true
    config.tab_bar_at_bottom = false
    config.show_close_tab_button_in_tabs = true
    config.show_new_tab_button_in_tab_bar = false
    config.hide_tab_bar_if_only_one_tab = true

    config.cursor_blink_rate = 500
    config.animation_fps = 60
    config.harfbuzz_features = { 'calt = 0', 'clig = 0', 'liga = 0' }
    config.font_size = 14.8
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
