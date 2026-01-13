{ pkgs, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
in
{
  home.packages = with pkgs; [
    # Dev
    gcc
    git
    gnumake
    nix-your-shell

    # Dev QoL
    btop # better top
    fd # find alternative
    tldr # man alternative

    # Utilities
    chezmoi

    # Others
    discord
  ];
}
