{ pkgs, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
in
{
  home.packages = with pkgs; [
    # Dev
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
    discord
  ];
}
