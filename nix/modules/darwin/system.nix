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
        "com.apple.screensaver" = {
          # スクリーンセーバー開始後パスワード要求
          askForPassword = 1;
          askForPasswordDelay = 0;
        };
        "com.apple.screencapture" = {
          location = "~/Desktop";
          type = "png";
        };
        "com.apple.Spotlight" = {
          orderedItems = [
            { enabled = 1; name = "APPLICATIONS"; }
            { enabled = 1; name = "SHORTCUTS"; }
            # 以下、不要な項目をすべて無効化
            { enabled = 0; name = "ACTIONS"; }
            { enabled = 0; name = "CLIPBOARD"; }
            { enabled = 0; name = "DIRECTORIES"; }
            { enabled = 0; name = "DOCUMENTS"; }
            { enabled = 0; name = "PDF"; }
            { enabled = 0; name = "MESSAGES"; }
            { enabled = 0; name = "CONTACT"; }
            { enabled = 0; name = "EVENT_TODO"; }
            { enabled = 0; name = "IMAGES"; }
            { enabled = 0; name = "BOOKMARKS"; }
            { enabled = 0; name = "MUSIC"; }
            { enabled = 0; name = "MOVIES"; }
            { enabled = 0; name = "PRESENTATIONS"; }
            { enabled = 0; name = "SPREADSHEETS"; }
            { enabled = 0; name = "SOURCE"; }
            { enabled = 0; name = "MENU_DEFINITION"; }
            { enabled = 0; name = "MENU_OTHER"; }
            { enabled = 0; name = "MENU_CONVERSION"; }
            { enabled = 0; name = "MENU_EXPRESSION"; }
            { enabled = 0; name = "MENU_SPOTLIGHT_SUGGESTIONS"; }
          ];
        };
        # "com.apple.screencapture" = {
        #   location = "~/Documents";
        #   type = "png";
        # };
        NSGlobalDomain = {
          WebKitDeveloperExtras = true;
        };
      };
      NSGlobalDomain = {
        # トラックパッドのスクロール方向
        "com.apple.swipescrolldirection" = false;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        AppleShowAllExtensions = true;
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
        # ホットコーナー(右下)でデスクトップ表示
        wvous-br-corner = 4;
        # ホットコーナー(左上)未指定
        wvous-tl-corner = 1;
        # ホットコーナー(右上)でミッションコントロール
        wvous-tr-corner = 2;
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
        show-thumbnail = false;
        disable-shadow = true;
      };
    };
  };
  # system.stateVersion = 5;
  # system.primaryUser = username;

  # system.defaults.finder.AppleShowAllFiles = true;
  # system.defaults.finder.FXPreferredViewStyle = "clmv";
  # system.activationScripts.postActivation.text = lib.mkAfter ''
  #   /usr/bin/killall Finder >/dev/null 2>&1 || true
  # '';

  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.reattach = true;

  # ============================================================
  # User / Shell
  # ============================================================
  users.users.${username} = {
    home = identity.homeDirectory;
    shell = pkgs.zsh;
  };
  programs = {
    zsh.enable = true;
  };
  # programs.zsh.enable = true;

  # ============================================================
  # System Packages
  # ============================================================
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
