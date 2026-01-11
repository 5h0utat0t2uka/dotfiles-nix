{ config, pkgs, lib, identity, ... }:

let
  username = identity.username;
  nixBin = "/nix/var/nix/profiles/default/bin";
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
        "com.apple.desktopservices" = {
          # .DS_Storeファイルを書き込まない
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.inputmethod.Kotoeri" = {
          # ライブ変換無効
          JIMPrefLiveConversionKey = 0;
          JIMPrefAutocorrectionKey = 0;
        };

        "com.apple.spotlight" = {
          orderedItems = [
            { enabled = true; name = "APPLICATIONS"; }
            { enabled = true; name = "SHORTCUTS"; }
            # 以下、不要な項目をすべて無効化
            { enabled = false; name = "ACTIONS"; }
            { enabled = false; name = "CLIPBOARD"; }
            { enabled = false; name = "DIRECTORIES"; }
            { enabled = false; name = "DOCUMENTS"; }
            { enabled = false; name = "PDF"; }
            { enabled = false; name = "MESSAGES"; }
            { enabled = false; name = "CONTACT"; }
            { enabled = false; name = "EVENT_TODO"; }
            { enabled = false; name = "IMAGES"; }
            { enabled = false; name = "BOOKMARKS"; }
            { enabled = false; name = "MUSIC"; }
            { enabled = false; name = "MOVIES"; }
            { enabled = false; name = "PRESENTATIONS"; }
            { enabled = false; name = "SPREADSHEETS"; }
            { enabled = false; name = "SOURCE"; }
            { enabled = false; name = "MENU_DEFINITION"; }
            { enabled = false; name = "MENU_OTHER"; }
            { enabled = false; name = "MENU_CONVERSION"; }
            { enabled = false; name = "MENU_EXPRESSION"; }
            { enabled = false; name = "MENU_SPOTLIGHT_SUGGESTIONS"; }
          ];
        };
        # "com.apple.screencapture" = {
        #   location = "~/Documents";
        #   type = "png";
        # };
      };
      NSGlobalDomain = {
        # トラックパッドのスクロール方向
        "com.apple.swipescrolldirection" = false;
        # トラックパッドのスピード
        # 範囲: 0.0 ~ 3.0
        # デフォルト: 1.0
        "com.apple.trackpad.scaling" = 2.5;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        AppleShowAllExtensions = true;
        WebKitDeveloperExtras = true;
        # キーリピート速度（最速）
        # 範囲: 120（遅い） ~ 2（最速）
        # UIでは6段階: 120, 90, 60, 30, 12, 6, 2
        # 最速 = 2
        KeyRepeat = 2;

        # キーリピート開始までの遅延（最速）
        # 範囲: 120（長い） ~ 15（短い）
        # UIでは6段階: 120, 94, 68, 35, 25, 15
        # 最速 = 15
        InitialKeyRepeat = 15;
      };

      dock = {
        # 自動非表示を有効にする
        autohide = true;
        # ホバー時の拡大を無効
        magnification = false;
        # 最近使用したアプリケーションを表示しない
        show-recents = false;
        # 開いているアプリケーションのみを表示する
        static-only = true;
        # ホットコーナー(左下)でスクリーンセーバ
        wvous-bl-corner = 5;
        # ホットコーナー(右下)未指定
        wvous-br-corner = 1;
        # ホットコーナー(左上)未指定
        wvous-tl-corner = 1;
        # ホットコーナー(右上)でデスクトップ表示
        wvous-tr-corner = 4;
      };

      finder = {
        # 拡張子を常に表示する
        AppleShowAllExtensions = true;
        # 隠しファイルを常に表示する
        AppleShowAllFiles = true;
        # カラム表示
        FXPreferredViewStyle = "clmv";
      };

      menuExtraClock = {
        # メニューバーの時計を24時間表示にする
        Show24Hour = true;
        # 常に日付を表示する
        ShowDate = 1;
        # 日付を表示する
        ShowDayOfMonth = true;
        # 曜日を表示する
        ShowDayOfWeek = true;
        # 秒は表示しない
        ShowSeconds = false;
      };

      trackpad = {
        # トラックパッドの右クリックを有効にする
        TrackpadRightClick = true;
      };

      screencapture = {
        # スクリーンショットのサムネイル無効
        location = "~/Desktop";
        type = "png";
        show-thumbnail = false;
        disable-shadow = true;
      };
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.reattach = true;

  # ============================================================
  # User / Shell
  # ============================================================
  users.users.${username} = {
    home = identity.homeDirectory;
    shell = pkgs.zsh;
  };
  # programs = {
  #   zsh.enable = true;
  # };
  # programs.zsh.enable = true;
  programs.zsh = {
    enable = true;
    promptInit = "";
    enableCompletion = false;
    enableGlobalCompInit = false;
  };

  # ============================================================
  # System Packages
  # ============================================================
  # environment.etc."zshrc".source = builtins.path {
  #   path = ../../assets/etc/zshrc;
  #   name = "zshrc";
  # };
  environment.etc."zshrc".source = lib.mkForce (builtins.path {
    path = ../../assets/etc/zshrc;
    name = "zshrc";
  });
  environment.systemPackages = [
    pkgs.pam-reattach
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.geist-mono
    source-han-code-jp
    shcode-jp-zen-haku
    udev-gothic-nf
  ];

  # ============================================================
  # Automatic Garbage Collection (launchd, root)
  # 毎週日曜日にAM3:00に`gc`
  # sudo tail -n 200 /var/log/nix-gc.log 2>/dev/null || true
  # ============================================================
  launchd.daemons.nix-gc = {
    command = "${nixBin}/nix-collect-garbage --delete-older-than 14d";
    serviceConfig = {
      RunAtLoad = false;
      StartCalendarInterval = [
        {
          Weekday = 0;
          Hour = 3;
          Minute = 0;
        }
      ];
      StandardOutPath = "/var/log/nix-gc.log";
      StandardErrorPath = "/var/log/nix-gc.log";
    };
  };

  # ============================================================
  # Nix Store Optimization (hard-link identical files)
  # 毎週日曜日にAM4:00に`optimise`
  # sudo tail -n 200 /var/log/nix-optimise.log 2>/dev/null || true
  # ============================================================
  launchd.daemons.nix-optimise = {
    command = "${nixBin}/nix store optimise";
    serviceConfig = {
      RunAtLoad = false;
      StartCalendarInterval = [
        {
          Weekday = 0;
          Hour = 4;
          Minute = 0;
        }
      ];
      StandardOutPath = "/var/log/nix-optimise.log";
      StandardErrorPath = "/var/log/nix-optimise.log";
    };
  };
}
