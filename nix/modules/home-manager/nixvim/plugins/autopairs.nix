{ ... }:

{
  plugins.nvim-autopairs = {
    enable = true;

    # plugins.treesitter.enable = true; に移行済みであること。
    settings = {
      check_ts = true;
    };
  };
}
