{ config, pkgs, lib, identity, ... }:

let
  username = identity.username;
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
        # "com.apple.screencapture" = {
        #   location = "~/Documents";
        #   type = "png";
        # };
        # NSGlobalDomain = {
        #   WebKitDeveloperExtras = true;
        # };
      };
      NSGlobalDomain = {
        # トラックパッドのスクロール方向
        "com.apple.swipescrolldirection" = false;
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
      # keyboard = {
      #   enableKeyMapping = true;
      #   remapCapsLockToControl = true;
      # };
    };
  };
  # system.stateVersion = 5;
  # system.primaryUser = username;

  # system.defaults.finder.AppleShowAllFiles = true;
  # system.defaults.finder.FXPreferredViewStyle = "clmv";
  # system.activationScripts.postActivation.text = lib.mkAfter ''
  #   /usr/bin/killall Finder >/dev/null 2>&1 || true
  # '';

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
  environment.systemPackages = [ ];

  fonts.packages = with pkgs; [
    nerd-fonts.geist-mono
    source-han-code-jp
    udev-gothic-nf
  ];
}
