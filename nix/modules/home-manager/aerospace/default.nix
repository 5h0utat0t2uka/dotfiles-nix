{ ... }:

{
  programs.aerospace = {
    enable = false;
    launchd.enable = false;

    settings = {
      config-version = 2;
      start-at-login = false;
      on-window-detected = [
        {
          check-further-callbacks = true;
          run = "layout floating";
        }
        {
          "if.app-id" = "com.apple.Safari";
          run = "move-node-to-workspace 1";
        }
        {
          "if.app-id" = "com.apple.finder";
          run = "move-node-to-workspace 1";
        }
        {
          "if.app-id" = "dev.zed.Zed";
          run = "move-node-to-workspace 2";
        }
        {
          "if.app-id" = "com.mitchellh.ghostty";
          run = "move-node-to-workspace 3";
        }
        {
          "if.app-id" = "com.apple.mail";
          run = "move-node-to-workspace 4";
        }
      ];
      mode.main.binding = {
        cmd-1 = "workspace 1";
        cmd-2 = "workspace 2";
        cmd-3 = "workspace 3";
        cmd-4 = "workspace 4";
      };
    };
  };
}
