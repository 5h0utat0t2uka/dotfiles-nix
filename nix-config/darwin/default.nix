{ pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc.automatic = true;

  # macOS設定（最低限）
  programs.zsh.enable = true;

  # Nixで入れるCLI（まずは最小、後から増やす）
  environment.systemPackages = with pkgs; [
    git
    gnupg
    jq
    ripgrep
    fd
    fzf
    bat
    eza
    neovim
    tmux
    zoxide
    direnv
    gh
    ghq
    wget
    tree
  ];

  # Homebrew を nix-darwin から宣言的に管理（GUI/caskはまずここ）
  homebrew = {
    enable = true;

    taps = [
      "olets/tap"
      "romkatv/powerlevel10k"
      "ryota2357/pleck-jp"
      "xwmx/taps"
      # 必要になったら追加（osx-cross, qmk 等）
    ];

    brews = [
      "chezmoi"
      "colima"
      "docker"
      "difftastic"
      "mise"
      "pass"
      "pass-otp"
      "pinentry-mac"
      "terminal-notifier"
      "zellij"
      "zsh-autosuggestions"
      "zsh-completions"
      "zsh-syntax-highlighting"
      "olets/tap/zsh-abbr"
      "xwmx/taps/nb"
    ];

    casks = [
      "ghostty"
      "karabiner-elements"
      "visual-studio-code"
      "zed"
      "google-chrome"
      "firefox"
      "cyberduck"
      "font-geist-mono-nerd-font"
      "font-source-han-code-jp"
      "font-udev-gothic-nf"
    ];

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
    };
  };

  # darwin-rebuild が参照するバージョン番号（初回は適当でOK、更新は後で）
  system.stateVersion = 5;
}
