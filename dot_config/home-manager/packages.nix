{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Dev
    gcc
    git
    gnumake

    # Dev QoL
    btop # better top
    fd   # find alternative
    tldr # man alternative

    # Utilities
    chezmoi

    # Kitty dependency
    (import (fetchTarball "https://github.com/nix-community/nixGL/archive/main.tar.gz") { })
    .auto.nixGLDefault

    # Others
    discord
    spotify
    vivaldi
  ];
}
