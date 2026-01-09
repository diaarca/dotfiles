{ pkgs, lib, ... }: # Add lib here

let
  isLinux = pkgs.stdenv.isLinux;
in
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    withPython3 = true;
    extraPackages = with pkgs; [
      # Dependencies
      fzf # for file finder (<leader>+ff)
      ripgrep # for live grep (<leader>+fw)

      # Format
      stylua
      black
      clang-tools
      pkgs.nodePackages.prettier
      nixfmt-rfc-style
      tex-fmt

      # Highlight
      tree-sitter
      nodejs
      vimPlugins.nvim-treesitter-parsers.vim
      vimPlugins.nvim-treesitter-parsers.lua
      vimPlugins.nvim-treesitter-parsers.vimdoc
      vimPlugins.nvim-treesitter-parsers.python
      vimPlugins.nvim-treesitter-parsers.bash
      vimPlugins.nvim-treesitter-parsers.c
      vimPlugins.nvim-treesitter-parsers.cpp
      vimPlugins.nvim-treesitter-parsers.latex
      vimPlugins.nvim-treesitter-parsers.markdown
      vimPlugins.nvim-treesitter-parsers.java
    ];
  };
}
