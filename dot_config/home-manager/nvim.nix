{ pkgs, lib, ... }: # Add lib here

let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    withPython3 = true;
    withRuby = true;
    extraPackages =
      with pkgs;
      [
        # Dependencies
        fzf # for file finder (<leader>+ff)
        ripgrep # for live grep (<leader>+fw)
        lua51Packages.luarocks
        imagemagick # image.nvim
        curl # for img-clip.nvim web images
      ]
      ++ lib.optionals isDarwin [
        pngpaste # for img-clip.nvim (macOS)
      ]
      ++ lib.optionals isLinux [
        xclip # for img-clip.nvim (Linux X11)
        wl-clipboard # for img-clip.nvim (Linux Wayland)
      ]
      ++ (with pkgs; [
        # Format
        stylua
        black
        clang-tools
        prettier
        nixfmt
        tex-fmt
        bibtex-tidy
        typstyle
        jsonfmt

        # Highlight
        tree-sitter
        nodejs
        vimPlugins.supermaven-nvim
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
        vimPlugins.nvim-treesitter-parsers.typst
      ]);
  };
}
