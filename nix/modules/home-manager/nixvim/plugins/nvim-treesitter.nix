{ pkgs, ... }:
{
  extraPlugins = with pkgs.vimPlugins; [
    (nvim-treesitter.withPlugins (p: [
      p.lua p.vim p.vimdoc p.query
      p.typescript p.tsx p.json p.javascript
      p.html p.css p.nix p.astro
      p.markdown p.markdown_inline
      p.just p.make p.yaml p.toml
      p.bash p.zsh p.dockerfile p.gitignore p.regex
    ]))
  ];
  autoCmd = [{
    event = "FileType";
    pattern = [
      "lua" "vim" "vimdoc" "query"
      "typescript" "tsx" "json" "javascript"
      "html" "css" "nix" "astro"
      "markdown" "markdown_inline"
      "just" "make" "yaml" "toml"
      "bash" "zsh" "dockerfile" "gitignore" "regex"
    ];
    callback.__raw = ''function(args) pcall(vim.treesitter.start, args.buf) end'';
  }];
}
