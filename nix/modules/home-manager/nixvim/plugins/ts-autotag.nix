{ ... }:

{
  plugins.ts-autotag = {
    enable = true;
    lazyLoad.settings = {
      event = [
        "BufReadPre"
        "BufNewFile"
      ];
    };
    settings = {
      opts = {
        enable_close = true;
        enable_rename = true;
        enable_close_on_slash = false;
      };
      per_filetype = {
        astro = {
          enable_close = true;
          enable_rename = true;
          enable_close_on_slash = false;
        };
      };
    };
  };
}
