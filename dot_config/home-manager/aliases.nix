{ pkgs, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
in
{
  home.shellAliases = {
    ll = "ls -l";
    la = "ls -a";
    icat = "kitten icat";
    kitty = if isLinux then "nixGL kitty" else "kitty";
    nv = "nvim";
  };
}
