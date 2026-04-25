{ pkgs, identity, ... }:

let
  username = identity.username;
  # userShell = "${pkgs.zsh}/bin/zsh";
in
{
  # ============================================================
  # nix-darwin
  # ============================================================
  nix.enable = false;

  # ============================================================
  # macOS
  # ============================================================
  system = {
    stateVersion = 5;
    primaryUser = username;
    defaults = {
      CustomUserPreferences = {
        # "com.google.Keystone.Agent" = {
        #   checkInterval = 0;
        # };
        # "com.Google.Chrome" = {
        #   checkInterval = 0;
        # };
        # "com.google.Keystone" = {
        #   updatePolicies = {
        #     global = {
        #       UpdateDefault = 3;
        #     };
        #     "com.google.Chrome" = {
        #       UpdateDefault = 3;
        #     };
        #   };
        # };
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.inputmethod.Kotoeri" = {
          JIMPrefLiveConversionKey = 0;
          JIMPrefAutocorrectionKey = 0;
        };
        # "com.apple.Spotlight" = {
        #   orderedItems = [
        #     { enabled = true; name = "APPLICATIONS"; }
        #     { enabled = true; name = "SHORTCUTS"; }
        #     { enabled = false; name = "ACTIONS"; }
        #     { enabled = false; name = "CLIPBOARD"; }
        #     { enabled = false; name = "DIRECTORIES"; }
        #     { enabled = false; name = "DOCUMENTS"; }
        #     { enabled = false; name = "PDF"; }
        #     { enabled = false; name = "MESSAGES"; }
        #     { enabled = false; name = "CONTACT"; }
        #     { enabled = false; name = "EVENT_TODO"; }
        #     { enabled = false; name = "IMAGES"; }
        #     { enabled = false; name = "BOOKMARKS"; }
        #     { enabled = false; name = "MUSIC"; }
        #     { enabled = false; name = "MOVIES"; }
        #     { enabled = false; name = "PRESENTATIONS"; }
        #     { enabled = false; name = "SPREADSHEETS"; }
        #     { enabled = false; name = "SOURCE"; }
        #     { enabled = false; name = "MENU_DEFINITION"; }
        #     { enabled = false; name = "MENU_OTHER"; }
        #     { enabled = false; name = "MENU_CONVERSION"; }
        #     { enabled = false; name = "MENU_EXPRESSION"; }
        #     { enabled = false; name = "MENU_SPOTLIGHT_SUGGESTIONS"; }
        #   ];
        # };

        # "com.apple.screencapture" = {
        #   location = "~/Documents";
        #   type = "png";
        # };
        # "com.apple.Safari" = {
        #   IncludeDevelopMenu = true;
        #   WebKitDeveloperExtrasEnabledPreferenceKey = true;
        # };
      };
      NSGlobalDomain = {
        "com.apple.swipescrolldirection" = false;
        "com.apple.trackpad.scaling" = 2.5;
        NSUseAnimatedFocusRing = true;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        AppleShowAllExtensions = true;
        KeyRepeat = 2;
        InitialKeyRepeat = 15;
      };
      dock = {
        autohide = true;
        tilesize = 50;
        magnification = false;
        show-recents = false;
        static-only = false;
        launchanim = false;
        mineffect = "scale";
        wvous-bl-corner = 5;
        wvous-br-corner = 1;
        wvous-tl-corner = 1;
        wvous-tr-corner = 4;
        mru-spaces = false;
        persistent-apps = [ ];
        persistent-others = [
          {
            folder = {
              path = "/Users/${username}/Desktop";
              showas = "list";
              displayas = "stack";
              arrangement = "date-added";
            };
          }
          {
            folder = {
              path = "/Users/${username}/Downloads";
              showas = "list";
              displayas = "stack";
              arrangement = "date-added";
            };
          }
        ];
      };
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        FXPreferredViewStyle = "clmv";
        NewWindowTarget = "Home";
        # CreateDesktop = false;
      };
      menuExtraClock = {
        Show24Hour = true;
        ShowDate = 1;
        ShowDayOfMonth = true;
        ShowDayOfWeek = true;
        ShowSeconds = false;
      };
      trackpad = {
        TrackpadRightClick = true;
      };
      screencapture = {
        location = "~/Desktop";
        type = "png";
        show-thumbnail = false;
        disable-shadow = true;
      };
      WindowManager = {
        GloballyEnabled = false;
      };
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.reattach = true;

  # ============================================================
  # User / Shell
  # ============================================================
  # users.users.${username} = {
  #   home = identity.homeDirectory;
  #   shell = userShell;
  # };

  # programs.zsh = {
  #   enable = true;
  #   promptInit = "";
  #   enableCompletion = false;
  #   enableGlobalCompInit = false;
  # };

  # environment.shells = [ pkgs.zsh ];

  # /etc/zshrc を最小化して nix-darwin 標準の初期化を無効化する。
  #
  # 経緯:
  # - nix-darwin 標準の /etc/zshrc は prompt / compinit / completion の初期化を含んでおり、これが user 側 .zshrc との責務重複や"compdef: unknown command" などの問題を引き起こしていた。
  # - 本構成では prompt (Powerlevel10k)、fpath、compinit、plugin のロード全てを user 側の .zshrc で責任を持って初期化している。
  # - そのため /etc/zshrc は「最小の入口」として固定し、拡張が必要なケースは /etc/zshrc.local で対応する設計。
  #
  # 変数の意図:
  # - __ETC_ZSHRC_SOURCED: 多重読み込み防止
  # - NOSYSZSHRC: system zshrc を無効化したいユースケースを尊重

  # environment.etc."zshrc".text = lib.mkForce ''
  #   if [ -n "$__ETC_ZSHRC_SOURCED" -o -n "$NOSYSZSHRC" ]; then
  #     return
  #   fi
  #   __ETC_ZSHRC_SOURCED=1
  #   if test -f /etc/zshrc.local; then
  #     source /etc/zshrc.local
  #   fi
  # '';

  # ============================================================
  # System Packages / Fonts
  # ============================================================
  environment.systemPackages = with pkgs; [
    pam-reattach
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.geist-mono
    # nerd-fonts.noto
    # nerd-fonts.iosevka
    # source-han-code-jp
    shcode-jp-zen-haku
    udev-gothic-nf
  ];
}
