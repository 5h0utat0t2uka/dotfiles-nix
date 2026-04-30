{ config, ... }:

{
  plugins.treesitter = {
    enable = true;
    # nvim-treesitter main branch 向けの nixvim native 設定
    # これにより FileType autocmd で vim.treesitter.start() が呼ばれる
    highlight.enable = true;
    # 既存設定では smartindent=true を使っており、treesitter indent は手動では有効化していなかったため、まずは false 相当にしておく
    # 有効化したい場合だけ true にする
    indent.enable = false;
    # 必要なら後で有効化
    folding.enable = false;
    grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      lua
      vim
      vimdoc
      query
      typescript
      tsx
      json
      javascript
      html
      css
      nix
      astro
      markdown
      markdown_inline
      just
      make
      yaml
      toml
      bash
      zsh
      dockerfile
      gitignore
      regex
    ];
  };
}
