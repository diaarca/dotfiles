{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Dev
    codex
    gcc
    gnumake
    lua51Packages.luarocks
    lua5_1
    nix-your-shell

    # Dev QoL
    btop # better top
    fd # find alternative
    tldr # man alternative

    # Utilities
    chezmoi
    imagemagick

    # Others
    obsidian
  ];
}
