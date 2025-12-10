{ pkgs, lib, ... }:

{
  home.packages = with pkgs;
    let
      commonPackages = [
        # Dev
        git
        gnumake

        # Dev QoL
        btop # better top
        fd   # find alternative
        tldr # man alternative

        # Utilities
        chezmoi
        home-manager
      ];

      linuxPackages = [
        # Kitty dependency
        (import (fetchTarball "https://github.com/nix-community/nixGL/archive/main.tar.gz") { })
        .auto.nixGLDefault
        gcc
        discord
        spotify
        vivaldi
      ];

      darwinPackages = [
        discord
        spotify
      ];

    in
    commonPackages
    ++ (lib.optionals pkgs.stdenv.isLinux linuxPackages)
    ++ (lib.optionals pkgs.stdenv.isDarwin darwinPackages);
}