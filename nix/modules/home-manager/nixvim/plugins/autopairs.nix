{ ... }:

{
  plugins.nvim-autopairs = {
    enable = true;

    lazyLoad.settings = {
      event = "InsertEnter";
    };

    settings = {
      check_ts = true;
    };
  };
}
